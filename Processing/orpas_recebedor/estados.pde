final int NO_USR = 0;
final int IN_AUT = 10;
final int NO_AUT_RECEB = 11;
final int NO_AUT_SENHA = 12;
final int NO_AUT_CONEX = 13;
final int NO_PAG = 20;
final int IN_PAG = 30;
final int NO_PAG_PAGAD = 31;
final int NO_PAG_CONEX = 32;
final int NO_PAG_VALOR = 33;
final int NO_SEN = 40;
final int IN_SEN = 50;
final int NO_SEN_SENHA = 51;
final int OK_SEN = 60;
final int OK_SEN_CONEX = 61;
final int OK_SEN_FUNDO = 62;
final int OK_PAG = 70;

int estado = NO_USR;
int estado_antes = -1;
int estado_proximo = NO_USR;

Cadastro vendedor;
Cadastro comprador;

Float pagar;

void estado_loop() {
  if (estado!= estado_antes) {
    estado_antes = estado;
    switch (estado) {
    case NO_USR: 
      senha_hide();
      alerta_hide();
      pagador_hide();
      recebedorPanel.setFocus(true);
      recebeConta.setFocus(true);

      break;
      //
    case IN_AUT: 
      if (!dbConnect()) {
        estado_proximo = NO_USR;
        estado_muda(NO_AUT_CONEX);
        dbClose();
        break;
      }
      vendedor = dbFromCartao(recebeConta.getText());
      dbClose();

      if (vendedor == null) {       
        statusText.setText("recebedor não encontrado");
        estado_proximo = NO_USR;
        estado_muda(NO_AUT_RECEB);
        break;
      }
      recebeNome.setText(vendedor.nome);
      statusText.setText("Localizado: "+vendedor.nome);

      // neste IF coloque sua rotina de verificação de senha
      if (true) { 
        statusText.appendText("\n"+"autenticado");
        estado_muda(NO_PAG);
      } else {
        statusText.appendText("\n"+"senha inválida");
        recebePass_renew();
        estado_proximo = NO_USR;
        estado_muda(NO_AUT_SENHA);
      }
      break;
      //
    case NO_PAG: 
      statusText.appendText("\n"+"Pronto para vendas");
      senha_hide();
      alerta_hide();
      recebedor_disable();
      pagador_show(); 
      pagaValor.setText("");
      pagaConta.setText("");
      pagaValor.setFocus(true);
      break;
      //
    case IN_PAG: 
      String pagarTxt = pagaValor.getText().replace(',', '.');
      pagar = parseFloat(pagarTxt);
      if (Float.isNaN(pagar) || pagar <=0) {
        statusText.setText("verifique o valor!");
        pagaValor.setText("");
        estado_proximo = NO_PAG;
        estado_muda(NO_PAG_VALOR);
        break;
      }

      if (!dbConnect()) {
        statusText.setText("Problemas de conexão!");
        estado_proximo = NO_PAG;
        estado_muda(NO_PAG_CONEX);
        dbClose();
        break;
      }
      comprador = dbFromCartao(pagaConta.getText());
      dbClose();

      if (comprador == null) {       
        statusText.setText("Pagador não encontrado");
        estado_proximo = NO_PAG;
        estado_muda(NO_PAG_PAGAD);
        break;
      }
      statusText.setText("Comprador: "+comprador.nome);

      //senha_show();
      //senhaPass.setFocus(true);
      //senhaNome.setText(comprador.nome);
      //senhaValor.setText(nf(pagar, 0, 2));
      estado_muda(NO_SEN);
      break;
      //
    case NO_SEN:
      alerta_hide();
      senha_show();
      senhaPass_renew();
      senhaPass.setFocus(true);
      senhaNome.setText(comprador.nome);
      senhaValor.setText(nf(pagar, 0, 2));
      break;
      //
    case IN_SEN: 
      statusText.appendText("\n"+"Verificando senha");

      // neste IF coloque sua rotina de verificação de senha
      if (true) {
        statusText.setText("senha OK");
        estado_muda(OK_SEN);
      } else {
        statusText.appendText("\n"+"senha inválida");
        estado_proximo = NO_SEN;
        estado_muda(NO_SEN_SENHA);
        senhaPass_renew();
        //senhaPass.setFocus(true);
      }
      break;
      //
    case OK_SEN:
      if (!dbConnect()) {
        statusText.setText("Problemas de conexão!");
        estado_proximo = NO_SEN;
        estado_muda(OK_SEN_CONEX);
        dbClose();
        break;
      }

      float result = dbTransfer (pagar, comprador.id, vendedor.id);  
      if (result <0) {
        statusText.setText("Verifique saldo, não efetuado");
        estado_proximo = NO_PAG;
        estado_muda(OK_SEN_FUNDO);
        dbClose();
        break;
      }
      dbClose();
      estado_proximo = NO_PAG;
      estado_muda(OK_PAG);

      break;
      //
    }
  }
}

void estado_muda(int novo) {
  switch (novo) {
  case IN_AUT: 
    alerta_show("Conectando recebedor", "");
    break;
    //
  case NO_AUT_CONEX: 
  case NO_PAG_CONEX: 
  case OK_SEN_CONEX: 
    alerta_show("Problemas de conexão!", "TENTAR DE NOVO");
    break;
    //
    //
  case NO_AUT_RECEB: 
    alerta_show("Conta de recebedor não encontrada!", "TENTAR DE NOVO");
    break;
    //
  case NO_AUT_SENHA: 
    alerta_show("Senha inválida!", "TENTAR DE NOVO");
    break;
    //
  case NO_PAG: 
    //statusText.appendText("\n"+"Pronto para vendas");
    //alerta_hide();
    //recebedor_disable();
    //pagador_show();    
    break;
    //
  case IN_PAG: 
    alerta_show("Localizando conta do pagador", "");
    break;
    //
  case NO_PAG_PAGAD: 
    alerta_show("Conta de pagador não encontrada!", "TENTAR DE NOVO");
    break;
    //
  case NO_PAG_VALOR: 
    alerta_show("Valor inválido!", "TENTAR DE NOVO");
    break;
    //
  case NO_SEN_SENHA: 
    senha_hide();
    alerta_show("Senha inválida!", "TENTAR DE NOVO");
    break;
    //
  case OK_SEN: 
    senha_hide();
    alerta_show("PROCESSANDO PAGAMENTO", "");
    //    alertaPanel.setLocalColorScheme(GCScheme.YELLOW_SCHEME);
    break;
    //
  case OK_SEN_FUNDO: 
    senhaPass_renew();
    senha_hide();
    alerta_show("VERIFIQUE O SALDO, NÃO EFETUADO", "OK");
    break;
    //
  case OK_PAG: 
    senha_hide();
    alerta_show("PAGAMENTO EFETUADO", "OK");
    alertaPanel.setLocalColorScheme(GCScheme.BLUE_SCHEME);
    alertaBotao.setLocalColorScheme(GCScheme.BLUE_SCHEME);
    break;
    //
  }
  estado = novo;
  //println("estado: "+estado);
}