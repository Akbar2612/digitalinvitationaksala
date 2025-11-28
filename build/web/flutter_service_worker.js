'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "3102480f0bab56c1aa57c141e137a858",
"assets/AssetManifest.bin.json": "4f185935f57b039e8d9fecd244bb56a7",
"assets/AssetManifest.json": "ff1ab53925f62b9706293e56839843cf",
"assets/assets/images/akbar.png": "18ef1b240d503d2237ef2b20d131d22d",
"assets/assets/images/Asset%25201.png": "899bc8342d28e065850e92e181a0e9c9",
"assets/assets/images/Asset%252010.png": "d50006856f63fa25748e20f299eb7ee5",
"assets/assets/images/Asset%252011.png": "a4295171ff303a6c3bc5aa08c5cdd7d7",
"assets/assets/images/Asset%252012.png": "9946bc2359ea46d8aa04b9f4f2ac49d8",
"assets/assets/images/Asset%252013.png": "83e3995325092c379160de3454fc5fa8",
"assets/assets/images/Asset%252014.png": "2f195d4b5c1b871aeca29fdb83d3564e",
"assets/assets/images/Asset%252015.png": "ef2d2fba9e4dd26021fbc529b07472d9",
"assets/assets/images/Asset%25205.png": "762cf8f7d28d637791666ddcff5f0bce",
"assets/assets/images/Asset%25206.png": "bb17615ac730f5b4bd83fdb9bfdd3728",
"assets/assets/images/Asset%25207.png": "aad30cf1ca73eb9a5db530fe577c2a10",
"assets/assets/images/Asset%25208.png": "95ae45aa99085afc4bb5f020185b3920",
"assets/assets/images/Asset%25209.png": "e34ec731b96271a60babbcefbd9ff6d6",
"assets/assets/images/bgcard.jpg": "5db9a6d6520aa16a76e15a541f28f2f0",
"assets/assets/images/bri.png": "b531e157832f734eb9d1621f8a4bce25",
"assets/assets/images/imagepreview.jpg": "699d941151a5bcab65dc48cf8ac82701",
"assets/assets/images/landscape1.jpeg": "a40553075d1ce7c063c29f285a55fe8d",
"assets/assets/images/landscape2.jpeg": "ccc336f2dbddd1ac1421d61da886de64",
"assets/assets/images/landscape3.jpeg": "f12e072d6b22ff17e6cf537b03ce46a2",
"assets/assets/images/mainbg.jpg": "0c6b3074051c09206410573dcbe70e53",
"assets/assets/images/mainbgdekstop.jpg": "3bb252ca0f0c9eda2da2c7392fda8366",
"assets/assets/images/mainbgdekstop2.jpg": "012d308daf6e9daede2a64d5309891c1",
"assets/assets/images/potrait1.jpeg": "fbd431d91b9a1f234f771d6bed97b1da",
"assets/assets/images/potrait2.jpeg": "0505a4e8ceb38a8048cd18d461dcdf51",
"assets/assets/images/potrait3.jpeg": "5606967f4e067eea75b48c200e110c37",
"assets/assets/images/secondbg.jpg": "5606967f4e067eea75b48c200e110c37",
"assets/assets/images/wulan.png": "782bf42a795b5decd81292c46267507b",
"assets/assets/music/musicbg.mp3": "7514a323b08c9b7e7cb45871f082250a",
"assets/FontManifest.json": "65f94acffb0ac2ee75d87cb32190e494",
"assets/fonts/MaterialIcons-Regular.otf": "35ca5041c2637cde6b2f50168a8e39b6",
"assets/NOTICES": "757e2d932267bb341a3e1b72643267aa",
"assets/packages/flutter_inappwebview/assets/t_rex_runner/t-rex.css": "5a8d0222407e388155d7d1395a75d5b9",
"assets/packages/flutter_inappwebview/assets/t_rex_runner/t-rex.html": "16911fcc170c8af1c5457940bd0bf055",
"assets/packages/flutter_inappwebview_web/assets/web/web_support.js": "509ae636cfdd93e49b5a6eaf0f06d79f",
"assets/packages/lucide_icons/assets/lucide.ttf": "f9ba0b4172a0beabfecd5857b55dfe72",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/canvaskit.js.symbols": "bdcd3835edf8586b6d6edfce8749fb77",
"canvaskit/canvaskit.wasm": "7a3f4ae7d65fc1de6a6e7ddd3224bc93",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.js.symbols": "b61b5f4673c9698029fa0a746a9ad581",
"canvaskit/chromium/canvaskit.wasm": "f504de372e31c8031018a9ec0a9ef5f0",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"canvaskit/skwasm.js.symbols": "e72c79950c8a8483d826a7f0560573a1",
"canvaskit/skwasm.wasm": "39dd80367a4e71582d234948adc521c0",
"favicon.png": "1fc190034bda2520662071b4fa2ce37c",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"flutter_bootstrap.js": "9f4ee897023141aaabf38e0852d349b7",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "3f63aaca7850d05f83f49b60b32b5a26",
"/": "3f63aaca7850d05f83f49b60b32b5a26",
"main.dart.js": "a6edca1eb54b14f465a12515b6e4f05d",
"manifest.json": "e5db2427c83ff2d57aae36c25c684c17",
"version.json": "ed5c44ae657a6ff85b2e1e023da2bff1"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
