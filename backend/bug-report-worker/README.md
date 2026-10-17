# Bug report Worker

Recibe los reportes de la app y los reenvía por email sin exponer la dirección de destino.

1. Cuenta gratuita en https://resend.com → crea una API key. (Con `onboarding@resend.dev` solo puedes enviar al email con el que te registraste: usa ese como destino.)
2. `cd backend/bug-report-worker && npx wrangler deploy`
3. `npx wrangler secret put RESEND_API_KEY` y `npx wrangler secret put TO_EMAIL`
4. Copia la URL `https://mhwilds-bug-report.<tu-subdominio>.workers.dev` a `BugReportService.endpoint` en `lib/utils/bug_report_service.dart`.

Límites: 3 archivos, 20 MB, 4000 caracteres (igual que la app). La URL es pública, así que cualquiera podría enviarla spam; si pasa, añade una regla de rate limiting en Cloudflare.
