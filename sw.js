// Service Worker: ทำให้ติดตั้งเป็นแอปได้ + เปิดแอปเร็วขึ้น + มี offline shell
// กลยุทธ์: network-first (ได้เวอร์ชันใหม่เสมอเมื่อออนไลน์) fallback เป็น cache เมื่อออฟไลน์
const CACHE = "ccapp-v1";
const ASSETS = [
  "./",
  "index.html",
  "config.js",
  "supabase.min.js",
  "manifest.json",
  "icons/icon-180.png",
  "icons/icon-192.png",
  "icons/icon-512.png",
  "icons/maskable-512.png",
];

self.addEventListener("install", (e) => {
  e.waitUntil(
    caches.open(CACHE).then((c) => c.addAll(ASSETS)).then(() => self.skipWaiting())
  );
});

self.addEventListener("activate", (e) => {
  e.waitUntil(
    caches.keys()
      .then((keys) => Promise.all(keys.filter((k) => k !== CACHE).map((k) => caches.delete(k))))
      .then(() => self.clients.claim())
  );
});

self.addEventListener("fetch", (e) => {
  const url = new URL(e.request.url);
  // ปล่อย API ของ Supabase และ request ข้ามโดเมนผ่านตรงๆ ไม่ cache
  if (e.request.method !== "GET" || url.origin !== self.location.origin) return;
  e.respondWith(
    fetch(e.request)
      .then((res) => {
        const copy = res.clone();
        caches.open(CACHE).then((c) => c.put(e.request, copy));
        return res;
      })
      .catch(() =>
        caches.match(e.request, { ignoreSearch: true })
          .then((r) => r || (e.request.mode === "navigate" ? caches.match("index.html") : undefined))
      )
  );
});
