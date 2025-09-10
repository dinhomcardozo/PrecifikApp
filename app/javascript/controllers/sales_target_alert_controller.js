document.addEventListener("turbo:load", () => {
  const lastShownKey = "salesTargetAlertLastShown";

  function shouldShowAlert() {
    const lastShown = localStorage.getItem(lastShownKey);
    if (!lastShown) return true;
    const diffHours = (Date.now() - parseInt(lastShown, 10)) / (1000 * 60 * 60);
    return diffHours >= 1;
  }

  if (shouldShowAlert()) {
    fetch("/sales_targets/alert_data.json")
      .then(res => res.json())
      .then(data => {
        let messages = [];

        if (data.vencendo.length > 0) {
          const produtos = data.vencendo.map(p => p.product).join(", ");
          messages.push(`As metas de vendas definidas para ${produtos} vencem hoje. Clique aqui e as ajuste.`);
        }

        if (data.vencidas.length > 0) {
          const produtos = data.vencidas.map(p => p.product).join(", ");
          messages.push(`As metas de vendas definidas para ${produtos} já venceram. Clique aqui e as ajuste.`);
        }

        if (messages.length > 0) {
          document.getElementById("salesTargetAlertBody").innerHTML = messages.join("<br><br>");
          const modal = new bootstrap.Modal(document.getElementById("salesTargetAlertModal"));
          modal.show();
          localStorage.setItem(lastShownKey, Date.now().toString());
        }
      });
  }
});