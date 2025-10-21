import Quill from "quill";
import "quill/dist/quill.snow.css";

document.addEventListener("DOMContentLoaded", () => {
  const editorContainer = document.querySelector("#quill-editor");
  const hiddenInput = document.querySelector("#message_body");

  if (editorContainer && hiddenInput) {
    console.log("Quill script carregado!");

    const toolbarOptions = [
      [{ 'font': [] }, { 'size': [] }],
      ['bold', 'italic', 'underline', 'strike'],
      [{ 'color': [] }, { 'background': [] }],
      [{ 'script': 'sub'}, { 'script': 'super' }],
      [{ 'header': 1 }, { 'header': 2 }, 'blockquote', 'code-block'],
      [{ 'list': 'ordered'}, { 'list': 'bullet' }, { 'indent': '-1'}, { 'indent': '+1' }],
      [{ 'direction': 'rtl' }, { 'align': [] }],
      ['link', 'image', 'video', 'table'],
      ['clean']
    ];

    const quill = new Quill(editorContainer, {
      theme: "snow",
      modules: {
        toolbar: toolbarOptions
      }
    });

    // Se já houver conteúdo (modo edição), carrega no Quill
    if (hiddenInput.value) {
      quill.root.innerHTML = hiddenInput.value;
    }

    // Atualiza o campo hidden sempre que o conteúdo mudar
    quill.on("text-change", () => {
      hiddenInput.value = quill.root.innerHTML;
    });
  }
});