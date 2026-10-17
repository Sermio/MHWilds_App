
<h1>Monster Hunter Assistant</h1>

<h2>Description</h2>
<p>
  The <strong>Monster Hunter Assistant</strong> is a mobile application developed in Flutter that allows users to explore and discover information about monsters and decorations from the popular game <em>Monster Hunter Wilds</em>. The app features an intuitive interface that enables users to easily access details about the monsters, their abilities, and the game maps.
</p>

<h2>Features</h2>
<ul>
  <li><strong>Monster Visualization</strong>: Users can browse a list of monsters, view their weaknesses, abilities, images, and descriptions.</li>
  <li><strong>Decoration Details</strong>: The app allows users to explore different decorations and their associated skill effects.</li>
  <li><strong>Armor & Builds</strong>: Users can check armor sets, their skills, and create personalized builds.</li>
  <li><strong>Skills List</strong>: A comprehensive list of skills available in the game, detailing their effects and which equipment grants them.</li>
  <li><strong>Materials List</strong>: Users can browse materials, see where to obtain them, and their crafting uses.</li>
  <li><strong>Filtering System</strong>: Users can filter the list of monsters, decorations, armor, skills, and materials using a search field for more efficient navigation.</li>
  <li><strong>Map Images</strong>: Images of different map areas in the game are included, displaying zones and available camps.</li>
  <li><strong>Asynchronous Loading</strong>: The app uses <code>FutureBuilder</code> and caching to load data efficiently, displaying a loading indicator while data is being fetched.</li>
  <li><strong>Animations & UI Feedback</strong>: Various animations help guide the user, making interactive elements clearer and enhancing usability.</li>
</ul>

<h2>Technologies Used</h2>
<ul>
  <li><strong>Flutter</strong>: For developing the user interface.</li>
  <li><strong>Dart</strong>: Programming language used in the application.</li>
  <li><strong>API & Local Storage</strong>: Custom APIs are utilized to fetch and cache information about monsters, decorations, and armor sets.</li>
</ul>

<h2>Architecture</h2>
<p>Data flows through four layers: <strong>API → cache → providers → UI</strong>.</p>
<ul>
  <li><strong>API</strong> (<code>lib/api/</code>): <code>ApiClient</code> (timeout, one retry, typed exceptions) and one static class per endpoint. The language is never global: every request receives its API language.</li>
  <li><strong>Cache</strong>: <code>CachedApi</code> + <code>CacheStore</code> keep the raw JSON on disk per language and revalidate it against <code>/version</code> (stale-while-revalidate).</li>
  <li><strong>Providers</strong> (<code>lib/providers/</code>): every catalog extends <code>CatalogProvider&lt;T, F&gt;</code> (load state, immutable filter <code>F</code>, pure <code>filterX</code> functions in <code>providers/filters/</code>). <code>dataProviders()</code> binds them to <code>LocaleProvider</code>, so changing language reloads the data (from disk if already cached).</li>
  <li><strong>UI</strong> (<code>lib/screens/</code>, <code>lib/components/</code>): sections are declared once in the <code>AppSection</code> enum; big screens are split into section widgets under <code>lib/screens/&lt;name&gt;/</code>. Theme tokens: <code>GameColors</code> (theme extension), <code>AppSpacing</code>, <code>AppRadius</code>.</li>
</ul>

<h3>Offline mode</h3>
<p>After the first load each list opens from the on-disk cache. Without a network the cached data is shown with an "offline" banner and pull-to-refresh retries; with no cache the list shows an error with a retry button.</p>

<h3>Regenerating files</h3>
<ul>
  <li><strong>Translations</strong>: edit <code>lib/l10n/app_*.arb</code> (the English file is the template) and run <code>flutter gen-l10n</code>.</li>
  <li><strong>Assets</strong>: images are WebP; <code>scripts/optimize_assets.py</code> converts them keeping the file name.</li>
  <li><strong>Test fixtures</strong>: <code>dart run scripts/fetch_fixtures.dart</code>.</li>
  <li><strong>Asset id maps (<code>asset_ids.g.dart</code>)</strong>: not generated yet; local images are still found through <code>EnNamesCache</code> (pending, see T34 in <code>docs/PLAN_MEJORAS.md</code>).</li>
</ul>

<h2>How to Run the Project</h2>
<ol>
  <li>Clone the repository to your local machine.</li>
  <li>Ensure you have Flutter and Dart installed.</li>
  <li>Run <code>flutter pub get</code> to install the dependencies.</li>
  <li>Run the app with <code>flutter run</code>.</li>
</ol>

<h2>Contributions</h2>
<p>
  If you wish to contribute to the application, please fork the repository and submit a pull request with your changes.
</p>

<h2>App Images</h2>
<p>
  Here are some images of the application screens with some of the functionalities.
</p>


Monsters list, filters and monster details:
<div style="display: flex; justify-content: space-around;">
  <img src="https://github.com/user-attachments/assets/fbd09192-5fd0-47b1-a0ee-89c87a881f5e" alt="Registro 1" width="200" hspace="30"/>
  <img src="https://github.com/user-attachments/assets/4be5ede5-7e0c-47b1-8dc3-2d50c11e6382" alt="Registro 2" width="200" hspace="30"/>
  <img src="https://github.com/user-attachments/assets/09456f31-78c0-439b-9fa6-e688a3eeb442" alt="Registro 2" width="200" hspace="30"/>
</div>

Weaknesses guide, materials and maps details:
<div style="display: flex; justify-content: space-around;">
  <img src="https://github.com/user-attachments/assets/75cb5870-82e6-417a-b74f-f58857f2f3ab" alt="Registro 1" width="200" hspace="30"/>
  <img src="https://github.com/user-attachments/assets/f3b5ee21-8d0d-4a18-a9e9-6199a76a7bfe" alt="Registro 2" width="200" hspace="30"/>
  <img src="https://github.com/user-attachments/assets/dfd8779a-1b41-4a4c-b674-73c5f0eaed70" alt="Registro 2" width="200" hspace="30"/>
</div>

Drawer, armors list and skill information:
<div style="display: flex; justify-content: space-around;">
  <img src="https://github.com/user-attachments/assets/e4a3eda0-9986-4c74-a0c5-f7948e05ff55" alt="Registro 1" width="200" hspace="30"/>
  <img src="https://github.com/user-attachments/assets/217d50e2-474f-47b4-af1d-48154b6d8463" alt="Registro 2" width="200" hspace="30"/>
  <img src="https://github.com/user-attachments/assets/a3ecf9e5-0c45-4b29-82fb-89cbd18211ca" alt="Registro 2" width="200" hspace="30"/>
</div>







