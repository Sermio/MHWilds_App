// Cloudflare Worker: recibe el reporte (multipart) de la app y lo reenvía por email con Resend.
// Secretos (wrangler secret put): RESEND_API_KEY, TO_EMAIL. El email de destino nunca llega a la app.
const MAX_FILES = 3;
const MAX_BYTES = 20 * 1024 * 1024;
const MAX_TEXT = 4000;

function toBase64(buf) {
  let bin = '';
  const bytes = new Uint8Array(buf);
  for (let i = 0; i < bytes.length; i += 0x8000) {
    bin += String.fromCharCode(...bytes.subarray(i, i + 0x8000));
  }
  return btoa(bin);
}

const esc = (s) => String(s).replace(/[&<>]/g, (c) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;' })[c]);
const field = (form, k, max) => String(form.get(k) ?? '').slice(0, max);

export default {
  async fetch(request, env) {
    if (request.method !== 'POST') return new Response('Method not allowed', { status: 405 });

    let form;
    try {
      form = await request.formData();
    } catch {
      return new Response('Bad request', { status: 400 });
    }

    const description = field(form, 'description', MAX_TEXT).trim();
    if (!description) return new Response('Missing description', { status: 400 });

    const files = form.getAll('files').filter((f) => typeof f !== 'string');
    const total = files.reduce((n, f) => n + f.size, 0);
    if (files.length > MAX_FILES || total > MAX_BYTES) return new Response('Too large', { status: 413 });

    const contact = field(form, 'contact', 200);
    const meta = ['app_version', 'platform', 'locale'].map((k) => `${k}: ${field(form, k, 200)}`);

    const attachments = [];
    for (const f of files) {
      attachments.push({ filename: (f.name || 'file').slice(0, 100), content: toBase64(await f.arrayBuffer()) });
    }

    const res = await fetch('https://api.resend.com/emails', {
      method: 'POST',
      headers: { Authorization: `Bearer ${env.RESEND_API_KEY.trim()}`, 'Content-Type': 'application/json' },
      body: JSON.stringify({
        from: 'MHWilds Bugs <onboarding@resend.dev>',
        to: [env.TO_EMAIL.trim()],
        subject: `[MHWilds bug] ${description.slice(0, 60).replace(/\s+/g, ' ')}`,
        reply_to: /^\S+@\S+\.\S+$/.test(contact) ? contact : undefined,
        html: `<pre style="white-space:pre-wrap;font:inherit">${esc(description)}</pre><hr><pre>${esc(meta.join('\n'))}\ncontact: ${esc(contact)}</pre>`,
        attachments,
      }),
    });
    if (!res.ok) console.error('Resend', res.status, await res.text());
    return new Response(null, { status: res.ok ? 204 : 502 });
  },
};
