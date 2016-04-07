void keyPressed() {
  //println((int)key);

  if (key == 10 || key == 9) {
    if (recebeConta.hasFocus()) recebePass.setFocus(true);
    else if (recebePass.hasFocus()) recebeLoginButton_event(recebeLogin, GEvent.CLICKED);
    else if (alertaBotao.hasFocus()) alertaBotao_event(alertaBotao, GEvent.CLICKED);
    else if (pagaValor.hasFocus()) pagaConta.setFocus(true);
    else if (pagaConta.hasFocus()) pagaConfirma_event(pagaConfirma, GEvent.CLICKED);
    else if (senhaPass.hasFocus()) senhaOK_event(senhaOK, GEvent.CLICKED);
  }
}