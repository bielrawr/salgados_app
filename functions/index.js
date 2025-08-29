
const functions = require("firebase-functions");
const { MercadoPagoConfig, Preference } = require("mercadopago");

// Pega o Access Token da configuração de ambiente do Firebase
const accessToken = functions.config().mercadopago.token;

// Inicializa o cliente do Mercado Pago com a nova sintaxe (v2)
const client = new MercadoPagoConfig({ accessToken });

exports.createPaymentPreference = functions.https.onCall(async (data, context) => {
  const items = data.items;

  if (!items || !Array.isArray(items) || items.length === 0) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "A função precisa ser chamada com um array de 'items'."
    );
  }

  // O corpo da preferência agora fica dentro de um objeto 'body'
  const preferenceRequest = {
    body: {
      items: items,
      payment_methods: {
        excluded_payment_types: [
          { id: "ticket" } // Exclui boletos e pagamentos em lotérica
        ]
      },
      payer: {
        // Você pode adicionar informações do pagador se tiver
        // email: "test_user_77352897@testuser.com",
      },
      back_urls: {
        success: "https://seusite.com/success", // URL de sucesso
        failure: "https://seusite.com/failure", // URL de falha
        pending: "https://seusite.com/pending", // URL pendente
      },
      auto_return: "approved",
    }
  };

  try {
    const preference = new Preference(client);
    const response = await preference.create(preferenceRequest);

    return {
      preferenceId: response.id,
      initPoint: response.init_point,
    };
  } catch (error) {
    console.error("Erro ao criar preferência no Mercado Pago:", error);
    throw new functions.https.HttpsError(
      "internal",
      "Não foi possível criar a preferência de pagamento."
    );
  }
});
