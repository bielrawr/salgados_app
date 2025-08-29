/// Constantes de mensagens em português para o público brasileiro
/// 
/// Este arquivo centraliza todas as mensagens do aplicativo em português
/// para garantir consistência e facilitar manutenção.

library messages;

/// Mensagens de validação de formulários
class ValidationMessages {
  static const String emailRequired = 'Email é obrigatório.';
  static const String emailInvalid = 'Por favor, insira um e-mail válido.';
  static const String passwordRequired = 'Senha é obrigatória.';
  static const String passwordTooShort = 'A senha deve ter pelo menos 6 caracteres.';
  static const String passwordTooWeak = 'Senha muito fraca. Use pelo menos 6 caracteres com letras e números.';
  static const String nameRequired = 'Nome é obrigatório.';
  static const String phoneRequired = 'Telefone é obrigatório.';
  static const String phoneInvalid = 'Por favor, insira um telefone válido.';
}

/// Mensagens de autenticação
class AuthMessages {
  // Títulos de alertas
  static const String loginErrorTitle = 'Erro no Login';
  static const String signupErrorTitle = 'Erro no Cadastro';
  static const String googleErrorTitle = '❌ Erro no Login com Google';
  static const String successTitle = '🎉 Sucesso!';
  static const String welcomeTitle = '🚀 Bem-vindo!';
  static const String signupSuccessTitle = '🎉 Cadastro Realizado!';
  
  // Mensagens de sucesso
  static const String loginSuccess = 'Login realizado com sucesso!\\nBem-vindo de volta à L&R Produtos Caseiros!';
  static const String googleLoginSuccess = 'Login com Google realizado com sucesso!\\nBem-vindo à L&R Produtos Caseiros!';
  static const String signupSuccess = 'Sua conta foi criada com sucesso!\\nVocê será redirecionado para a tela principal.';
  static const String passwordResetSuccess = 'Email de redefinição de senha enviado com sucesso!\\nVerifique sua caixa de entrada.';
  static const String logoutSuccess = 'Logout realizado com sucesso!';
  
  // Mensagens de erro específicas
  static const String userNotFound = 'Usuário não encontrado. Verifique o email digitado.';
  static const String wrongPassword = 'Senha incorreta. Tente novamente ou redefina sua senha.';
  static const String emailAlreadyInUse = 'Este email já está cadastrado. Tente fazer login ou use outro email.';
  static const String weakPassword = 'Senha muito fraca. Use pelo menos 6 caracteres.';
  static const String invalidEmail = 'Email inválido. Verifique o formato do email digitado.';
  static const String invalidCredential = 'Credenciais inválidas. Verifique seu email e senha.';
  static const String userDisabled = 'Esta conta foi desabilitada. Entre em contato com o suporte.';
  static const String tooManyRequests = 'Muitas tentativas de login. Aguarde alguns minutos e tente novamente.';
  static const String networkError = 'Erro de conexão. Verifique sua internet e tente novamente.';
  static const String operationNotAllowed = 'Esta operação não está habilitada. Entre em contato com o suporte.';
  static const String loginCancelled = 'Login cancelado pelo usuário.';
  static const String unexpectedError = 'Erro inesperado. Tente novamente ou entre em contato com o suporte.';
  
  // Mensagens de autenticação social
  static const String accountExistsWithDifferentCredential = 'Já existe uma conta com este email usando outro método de login.';
  static const String credentialAlreadyInUse = 'Esta credencial já está sendo usada por outra conta.';
  static const String popupBlocked = 'Popup bloqueado pelo navegador. Permita popups e tente novamente.';
  
  // Mensagens de sessão
  static const String requiresRecentLogin = 'Por segurança, faça login novamente para continuar.';
  static const String tokenExpired = 'Sua sessão expirou. Faça login novamente.';
}

/// Mensagens gerais do aplicativo
class AppMessages {
  // Loading
  static const String loading = 'Carregando...';
  static const String loadingProducts = 'Carregando produtos...';
  static const String loadingCategories = 'Carregando categorias...';
  static const String processing = 'Processando...';
  
  // Confirmações
  static const String confirmTitle = '🤔 Confirmar Ação';
  static const String confirmButton = 'Confirmar';
  static const String cancelButton = 'Cancelar';
  static const String okButton = 'OK';
  static const String closeButton = 'Fechar';
  
  // Carrinho
  static const String addToCartSuccess = 'Produto adicionado ao carrinho com sucesso!';
  static const String removeFromCartSuccess = 'Produto removido do carrinho.';
  static const String cartEmpty = 'Seu carrinho está vazio.';
  static const String cartTotal = 'Total do carrinho';
  
  // Pedidos
  static const String orderSuccess = 'Pedido realizado com sucesso!';
  static const String orderError = 'Erro ao processar pedido. Tente novamente.';
  static const String orderHistory = 'Histórico de pedidos';
  
  // Navegação
  static const String home = 'Início';
  static const String products = 'Produtos';
  static const String categories = 'Categorias';
  static const String cart = 'Carrinho';
  static const String profile = 'Perfil';
  static const String settings = 'Configurações';
  
  // Ações
  static const String login = 'Entrar';
  static const String signup = 'Cadastrar';
  static const String logout = 'Sair';
  static const String save = 'Salvar';
  static const String edit = 'Editar';
  static const String delete = 'Excluir';
  static const String add = 'Adicionar';
  static const String remove = 'Remover';
  static const String search = 'Pesquisar';
  static const String filter = 'Filtrar';
  static const String sort = 'Ordenar';
  
  // Estados
  static const String available = 'Disponível';
  static const String unavailable = 'Indisponível';
  static const String outOfStock = 'Fora de estoque';
  static const String inStock = 'Em estoque';
  
  // Erros gerais
  static const String genericError = 'Ocorreu um erro inesperado. Tente novamente.';
  static const String networkErrorGeneral = 'Erro de conexão. Verifique sua internet.';
  static const String permissionDenied = 'Permissão negada.';
  static const String notFound = 'Item não encontrado.';
  static const String serverError = 'Erro no servidor. Tente novamente mais tarde.';
}

/// Mensagens de interface do usuário
class UIMessages {
  // Placeholders
  static const String emailPlaceholder = 'Digite seu email';
  static const String passwordPlaceholder = 'Digite sua senha';
  static const String searchPlaceholder = 'Pesquisar produtos...';
  static const String namePlaceholder = 'Digite seu nome';
  static const String phonePlaceholder = 'Digite seu telefone';
  
  // Labels
  static const String email = 'E-mail';
  static const String password = 'Senha';
  static const String name = 'Nome';
  static const String phone = 'Telefone';
  static const String address = 'Endereço';
  static const String price = 'Preço';
  static const String quantity = 'Quantidade';
  static const String description = 'Descrição';
  
  // Links
  static const String noAccountSignup = 'Não tem uma conta? Cadastre-se';
  static const String hasAccountLogin = 'Já tem uma conta? Faça login';
  static const String forgotPassword = 'Esqueceu sua senha?';
  static const String resetPassword = 'Redefinir senha';
  
  // Divisores
  static const String orContinueWith = 'ou continue com';
  static const String orLoginWith = 'ou faça login com';
  
  // Botões sociais
  static const String continueWithGoogle = 'Continuar com Google';
  static const String loginWithGoogle = 'Entrar com Google';
}

/// Mensagens específicas do negócio
class BusinessMessages {
  static const String companyName = 'L&R Produtos Caseiros';
  static const String companySlogan = 'Sabor e Qualidade';
  static const String welcomeMessage = 'Bem-vindo à L&R Produtos Caseiros!';
  static const String aboutUs = 'Produtos caseiros feitos com carinho e ingredientes selecionados.';
  static const String contactUs = 'Entre em contato conosco';
  static const String workingHours = 'Horário de funcionamento';
  static const String delivery = 'Entrega';
  static const String pickup = 'Retirada';
  static const String orderNow = 'Peça agora';
  static const String viewMenu = 'Ver cardápio';
}