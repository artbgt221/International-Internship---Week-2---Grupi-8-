import { createServer } from "node:http";
import { readFile } from "node:fs/promises";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const folder = dirname(fileURLToPath(import.meta.url));

createServer(async (request, response) => {
  try {
    const fileName = request.url === "/" ? "index.html" : request.url.slice(1);
    const content = await readFile(join(folder, fileName));
    response.writeHead(200, {
      "Content-Type": fileName.endsWith(".html")
        ? "text/html; charset=utf-8"
        : "application/octet-stream",
    });
    response.end(content);
  } catch {
    response.writeHead(404);
    response.end("Not found");
  }
}).listen(4173, "127.0.0.1");
