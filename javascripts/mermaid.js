document$.subscribe(async function () {
  if (typeof mermaid === "undefined") {
    return;
  }

  mermaid.initialize({
    startOnLoad: false,
    securityLevel: "loose"
  });

  document.querySelectorAll(".jp-Mermaid").forEach(function (container) {
    container.classList.add("jp-RenderedMermaid");
  });

  await mermaid.run({
    querySelector: ".mermaid"
  });
});
