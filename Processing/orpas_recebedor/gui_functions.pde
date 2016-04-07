// Este arquivo comanda os elementos visuais do programa

// esta função faz os ajustes iniciais dos elementos visuais
void gui_setup() {
  // desabilita a entrada de dados. Janela usada apenas para mensagens do sistema
  mensagemPanel.setEnabled(false);

  // enquanto o Recebedor não estiver logado, o pagador fica escondido
  pagador_hide();

  recebeLogout.setVisible(false);
  recebeConectado.setVisible(false);

  alertaLabel.setFont(big_font);
  alertaBotao.setFont(mid_font);
  alerta_hide();

  senhaOK.setFont(big_font);
  senhaNome.setFont(mid_font);
  senhaValor.setFont(big_font);
  senha_hide();

  orpasLabel.setFont(big_font);
  pagaValor.setFont(big_font);
  mensagemRecebedor.setFont(mid_font);
}

// habilita a visualização do painel do pagador
void pagador_show() {
  pagadorPanel.setVisible(true);
}

// desabilita a visualização do painel do pagador
void pagador_hide() {
  pagadorPanel.setVisible(false);
}

// habilita a visualização do painel da senha
void senha_show() {
  senhaPanel.setVisible(true);
}

// desabilita a visualização do painel do senha
void senha_hide() {
  senhaPanel.setVisible(false);
}

// habilita a visualização do painel do alerta
void alerta_show(String mensagem, String botao) {
  alertaLabel.setText(mensagem);
  if (botao.length() ==0) {
    alertaPanel.setLocalColorScheme(GCScheme.ORANGE_SCHEME);
    alertaBotao.setVisible(false);
  } else {
    alertaPanel.setLocalColorScheme(GCScheme.RED_SCHEME);
    alertaBotao.setVisible(true);
    alertaBotao.setText(botao);
    alertaBotao.setFocus(true);
  }
  alertaPanel.setVisible(true);
}

// desabilita a visualização do painel do alerta
void alerta_hide() {
  alertaPanel.setVisible(false);
}

// habilita o acesso ao painel do pagador
void pagador_enable() {
  pagadorPanel.setEnabled(true);
}

// desabilita o acesso ao painel do pagador
void pagador_disable() {
  pagadorPanel.setEnabled(false);
}

// habilita o acesso ao painel do recebedor
void recebedor_enable() {
  recebedorPanel.setEnabled(true);
}

// desabilita o acesso ao painel do recebedor
void recebedor_disable() {
  recebeConectado.setVisible(true);
  recebeLogin.setVisible(false);
  recebeLogout.setVisible(false);
  recebePass.setVisible(false);
  recebePassLabel.setVisible(false);
  recebedorPanel.setEnabled(false);
}

void recebePass_renew() {
  recebePass.dispose();
  recebePass.dispose();
  recebePass = new GPassword(this, 20, 100, 250, 20);
  recebePass.setMaxWordLength(20);
  recebePass.setOpaque(true);
  recebePass.addEventHandler(this, "recebePass_event");
  recebedorPanel.addControl(recebePass);
}

void senhaPass_renew() {
  senhaPass.dispose();
  senhaPass.dispose();
  senhaPass = new GPassword(this, 20, 290, 350, 30);
  senhaPass.setMaxWordLength(20);
  senhaPass.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  senhaPass.setOpaque(true);
  senhaPass.addEventHandler(this, "senhaPass_event");
  senhaPanel.addControl(senhaPass);
}