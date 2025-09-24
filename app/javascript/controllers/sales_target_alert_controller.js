document.addEventListener("turbo:load", () => {
  if (!window.location.pathname.startsWith("/clients")) {
    return;
  }

  const lastShownKey = "salesTargetAlertLastShown";

  function shouldShowAlert() {
    const lastShown = localStorage.getItem(lastShownKey);
    if (!lastShown) return true;
    const diffHours = (Date.now() - parseInt(lastShown, 10)) / (1000 * 60 * 60);
    return diffHours >= 1;
  }

  if (shouldShowAlert()) {
    fetch("/clients/sales_targets/alert_data.json")
      .then(res => {
        if (!res.ok) {
          console.warn(`Falha ao buscar alert_data: ${res.status} ${res.statusText}`);
          return null; // não tenta processar
        }
        return res.json();
      })
      .then(data => {
        if (!data) return;

        let messages = [];

        if (Array.isArray(data.vencendo) && data.vencendo.length > 0) {
          const produtos = data.vencendo.map(p => p.product).join(", ");
          messages.push(`As metas de vendas definidas para ${produtos} vencem hoje. Clique aqui e as ajuste.`);
        }

        if (Array.isArray(data.vencidas) && data.vencidas.length > 0) {
          const produtos = data.vencidas.map(p => p.product).join(", ");
          messages.push(`As metas de vendas definidas para ${produtos} já venceram. Clique aqui e as ajuste.`);
        }

        if (messages.length > 0) {
          document.getElementById("salesTargetAlertBody").innerHTML = messages.join("<br><br>");
          const modal = new bootstrap.Modal(document.getElementById("salesTargetAlertModal"));
          modal.show();
          localStorage.setItem(lastShownKey, Date.now().toString());
        }
      })
      .catch(err => {
        console.error("Erro ao buscar alert_data:", err);
      });
  }
});