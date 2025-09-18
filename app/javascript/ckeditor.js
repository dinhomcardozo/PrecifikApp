document.addEventListener("DOMContentLoaded", function() {
  const editorElement = document.querySelector("#editor");
  if (editorElement) {
    ClassicEditor
      .create(editorElement, {
        toolbar: [
          'heading', '|',
          'bold', 'italic', 'underline', '|',
          'alignment:left', 'alignment:center', 'alignment:right', '|',
          'link', 'insertTable', 'imageUpload', '|',
          'undo', 'redo'
        ],
        table: {
          contentToolbar: ['tableColumn', 'tableRow', 'mergeTableCells']
        }
      })
      .catch(error => {
        console.error(error);
      });
  }
});