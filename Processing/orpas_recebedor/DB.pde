// baseado no codigo em http://www.vogella.com/tutorials/MySQLJava/article.html

String dbServer = "dbServer";
String dbPort = "3306";
String dbName = "dbName";
String dbUser = "dbUser";
String dbPass = "dbPass";

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import java.sql.Timestamp;
import java.util.Date;
import java.util.Properties;

Connection connect = null;
Statement statement = null;
ResultSet resultSet = null;

boolean dbConnect() {
  try {
    // This will load the MySQL driver, each DB has its own driver
    Class.forName("com.mysql.jdbc.Driver");
    // Setup the connection with the DB
    connect = DriverManager
      .getConnection("jdbc:mysql://"+dbServer+":"+dbPort+"/"+dbName+"?"
      + "user="+dbUser+"&password="+dbPass);
  } 
  catch (Exception e) {
    //println(e.toString());
    dbClose();
    return false;
  } 
  return true;
}

float dbSaldo(int id_) {
  float result =-10;
  try {
    // Statements allow to issue SQL queries to the database
    statement = connect.createStatement();
    // Result set get the result of the SQL query
    resultSet = statement
      .executeQuery("CALL `name`.`ver_saldo`("+id_+",@out);");

    resultSet.first();
    result = resultSet.getFloat(1);

    statement.close();
  }     
  catch (Exception e) {
    //println(e.toString());
  }   
  return result;
}

Cadastro dbFromCartao(String cartao) {
  Cadastro result = new Cadastro();
  try {
    // Statements allow to issue SQL queries to the database
    statement = connect.createStatement();
    // Result set get the result of the SQL query
    resultSet = statement
      .executeQuery("SELECT * FROM name.cadastro WHERE conta = \""+cartao+"\" OR cartao = \""+cartao+"\";");

    resultSet.first();
    result.id = resultSet.getInt("id");
    result.nome = resultSet.getString("nome");
    result.cartao = resultSet.getString("cartao");
    result.tipo = resultSet.getInt("tipo");
    result.saldo = resultSet.getFloat("saldo");
    result.conta = resultSet.getString("conta");
    result.senha = resultSet.getString("senha");

    statement.close();
  }     
  catch (Exception e) {
    //println(e.toString());
    result = null;
  }   
  return result;
}

float dbTransfer(float valor_, int pagador_, int recebedor_) {
  float result = -10;

  //if (dbSaldo(pagador_)<valor_) return -1;

  try {
    // Statements allow to issue SQL queries to the database
    statement = connect.createStatement();
    // Result set get the result of the SQL query
    resultSet = statement
      .executeQuery("CALL `name`.`transfer`(" + valor_ +", " + pagador_ + ", "+ recebedor_ + ");");
    resultSet.first();
    result = resultSet.getFloat(1);

    statement.close();
  }     
  catch (Exception e) {
    //println(e.toString());
  }   
  return result;
}


// You need to close the resultSet
void dbClose() {
  try {
    if (resultSet != null) resultSet.close();
  } 
  catch (Exception e) {
  }
  try {
    if (statement != null) statement.close();
  } 
  catch (Exception e) {
  }
  try {
    if (connect != null) connect.close();
  } 
  catch (Exception e) {
  }
}