// Compilado usando 
// * processing 3.01
// * biblioteca G4P 4.02
// * ferramenta G4P GUI Builder 4.0
// * Driver JDBC mysql-connector-java-5.1.38 na pasta code  



// importa biblioteca G4P
import g4p_controls.*;

// Prepara a fonte maior
import java.awt.Font;
Font big_font = new Font("Dialog", Font.PLAIN, 36);
Font mid_font = new Font("Dialog", Font.PLAIN, 18);


public void setup() {
  size(400, 600, JAVA2D);
  smooth();
  createGUI();
  gui_setup();
  //db_setup();
}

public void draw() {
  background(230);
  estado_loop();
}