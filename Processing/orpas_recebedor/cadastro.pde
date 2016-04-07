class Cadastro {
  int id;
  String nome;
  //String rg;
  //String cpf;
  String cartao;
  int tipo;
  float saldo;
  String conta;
  String senha;

  String toString() {
    return  
      "id:     "+id + "\n" +
      "nome:   " + nome + "\n" +
      "cartao: " + cartao + "\n" +
      "tipo:   " + tipo + "\n" +
      "saldo:  " + saldo + "\n" +
      "conta:  " + conta + "\n" +
      "senha:  " + senha + "\n"
      ;
  }
}