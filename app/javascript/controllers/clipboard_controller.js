import { Controller } from "@hotwired/stimulus"

document.addEventListener("click", async (e) => {
  const btn = e.target.closest("[data-copy]")
  if (!btn) return
  const text = btn.getAttribute("data-copy")
  try {
    await navigator.clipboard.writeText(text)
    btn.textContent = "Copied!"
  } catch {
    const ta = document.createElement("textarea")
    ta.value = text; ta.setAttribute("readonly", "")
    ta.style.position = "absolute"; ta.style.left = "-9999px"
    document.body.appendChild(ta); ta.select()
    document.execCommand("copy")
    document.body.removeChild(ta)
    btn.textContent = "Copied!"
  }
})
