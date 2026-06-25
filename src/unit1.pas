unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    btn_cargar: TButton;
    btn_puntos_mayores: TButton;
    btn_puntos: TButton;
    btn_modificar_puntaje: TButton;
    btn_puntos_niveles: TButton; // El botón nuevo que te pide crear el enunciado
    btn_puntaje_total: TButton;
    edt_jugador: TEdit;
    edt_puntos: TEdit;
    cmb_jugadores: TComboBox;   // El combo box para seleccionar al jugador
    edt_puntos_nv2: TEdit;
    edt_puntos_nv1: TEdit;
    lbl_jugadores1: TLabel;
    lbl_jugmayorvalor: TLabel;
    lbl_jugvaloralto: TLabel;
    lbl_tittle: TLabel;
    lbl_jugadores: TLabel;
    lbl_tittle1: TLabel;
    lbl_tittle2: TLabel;
    lbl_tittle3: TLabel;
    lbl_tittle4: TLabel;
    lbl_tittle5: TLabel;
    lbl_tittle6: TLabel;
    lbl_tittle7: TLabel;
    procedure btn_cargarClick(Sender: TObject);
    procedure btn_modificar_puntajeClick(Sender: TObject);
    procedure btn_puntaje_totalClick(Sender: TObject);
    procedure btn_puntosClick(Sender: TObject);
    procedure btn_puntos_nivelesClick(Sender: TObject); // Evento del botón nuevo
    procedure btn_puntos_mayoresClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

const
  max = 20;

var
  Form1: TForm1;
  nombres: array[1..max] of string;

  // MATRIZ 2D: 20 filas (jugadores) y 3 columnas (1: Inicial, 2: Nivel 1, 3: Nivel 2)
  puntos: array[1..max, 1..3] of integer;

  i: integer = 1;
  ii: integer = 1;

implementation

{$R *.lfm}

{ TForm1 }

// 1. BOTÓN CARGAR JUGADOR
procedure TForm1.btn_cargarClick(Sender: TObject);
var
   nombre_jugador: string;
begin
     nombre_jugador := trim(edt_jugador.text);

     if nombre_jugador = '' then
     begin
          showmessage('Por favor, ingrese un nombre válido.');
          exit;
     end;

     if i <= max then
     begin
          nombres[i] := nombre_jugador;

          // Metemos el nombre adentro del ComboBox de la pantalla
          cmb_jugadores.Items.Add(nombre_jugador);

          // Mostramos en la etiqueta de control usando la columna 1 (inicial) que arranca en 0
          lbl_jugadores.caption := lbl_jugadores.caption + #13#10 + inttostr(i) + '. ' + nombres[i] + '. Puntos Iniciales: ' + inttostr(puntos[i, 1]);

          i := i + 1;
          edt_jugador.text := ''; // Limpiamos el cuadro
     end
     else
          showmessage('El número de jugadores llegó a su límite.');
end;

procedure TForm1.btn_modificar_puntajeClick(Sender: TObject);
var
   pos, j, nivel_elegido, nuevo_valor: integer;
   seleccionado: string;
   encontrado: boolean;
begin
     // 1. Validamos que se haya seleccionado un jugador en el ComboBox
     if cmb_jugadores.ItemIndex = -1 then
     begin
          showmessage('Por favor, seleccione un jugador de la lista.');
          exit;
     end;

     // 2. Pedimos los datos de actualización mediante inputbox
     nivel_elegido := strtoint(inputbox('Modificar Puntaje', 'Ingrese el nivel a modificar (1=Inicial, 2=Nivel 1, 3=Nivel 2):', ''));

     // Validamos que el nivel ingresado sea correcto (columnas 1, 2 o 3)
     if (nivel_elegido < 1) or (nivel_elegido > 3) then
     begin
          showmessage('Error: El nivel debe ser 1, 2 o 3.');
          exit;
     end;

     nuevo_valor := strtoint(inputbox('Modificar Puntaje', 'Ingrese el nuevo puntaje para este nivel:', ''));

     // 3. Buscamos al jugador seleccionado en el arreglo global de nombres
     seleccionado := cmb_jugadores.Text;
     encontrado := false;
     pos := -1;

     for j := 1 to i - 1 do
     begin
          if nombres[j] = seleccionado then
          begin
               encontrado := true;
               pos := j; // Guardamos la fila de la matriz
               break;
          end;
     end;

     // 4. Si lo encontramos, modificamos la celda justa de la matriz 2D
     if encontrado then
     begin
          puntos[pos, nivel_elegido] := nuevo_valor;

          showmessage('¡Puntaje actualizado con éxito!' + #13#10 +
                      'Jugador: ' + nombres[pos] + #13#10 +
                      'Nivel: ' + inttostr(nivel_elegido) + ' Nuevo Valor: ' + inttostr(nuevo_valor) + ' pts.');
     end;
end;

procedure TForm1.btn_puntaje_totalClick(Sender: TObject);
var
   pos, j, suma_total: integer;
   seleccionado: string;
   encontrado: boolean;
begin
     if cmb_jugadores.ItemIndex = -1 then
     begin
          showmessage('Por favor, seleccione un jugador.');
          exit;
     end;

     seleccionado := cmb_jugadores.Text;
     encontrado := false;
     pos := -1;

     // Buscamos el jugador en el arreglo
     for j := 1 to i - 1 do
     begin
          if nombres[j] = seleccionado then
          begin
               encontrado := true;
               pos := j;
               break;
          end;
     end;

     // Si lo encontramos, sumamos las 3 columnas de su fila
     if encontrado then
     begin
          suma_total := puntos[pos, 1] + puntos[pos, 2] + puntos[pos, 3];

          showmessage('Jugador: ' + nombres[pos] + #13#10 +
                      'Puntaje Total acumulado: ' + inttostr(suma_total) + ' puntos.');
     end;
end;

// 2. BOTÓN INGRESAR PUNTOS BASE
procedure TForm1.btn_puntosClick(Sender: TObject);
var
   puntos_iniciales, puntos_nv1, puntos_nv2: integer;
   val_inicial, val_menor, val_identico: integer;
begin
     // 1. VALIDACIÓN: Que no dejen los cuadros vacíos
     if (edt_puntos.text = '') or (edt_puntos_nv1.text = '') or (edt_puntos_nv2.text = '') then
     begin
          showmessage('Por favor, complete los 3 cuadros de texto.');
          exit;
     end;

     randomize;

     // Generamos los 3 valores al azar que el usuario tiene que "descubrir" o superar
     val_inicial  := random(100); // Para nivel inicial (Mayor a este)
     val_menor    := random(100); // Para nivel 1 (Menor a este)
     val_identico := random(10);  // Para nivel 2 (Idéntico a este, un rango más chico para que sea posible embocarle)

     // Convertimos las entradas de la pantalla a números
     puntos_iniciales := strtoint(edt_puntos.text);
     puntos_nv1       := strtoint(edt_puntos_nv1.text);
     puntos_nv2       := strtoint(edt_puntos_nv2.text);

     if ii <= max then
     begin
          // --- REGLA 1: NIVEL INICIAL (Tiene que ser MAYOR) ---
          if puntos_iniciales > val_inicial then
               puntos[ii, 1] := puntos_iniciales
          else
               puntos[ii, 1] := 0; // Si no superó, 0 puntos

          // --- REGLA 2: NIVEL 1 (Tiene que ser MENOR) ---
          if puntos_nv1 < val_menor then
               puntos[ii, 2] := puntos_nv1
          else
               puntos[ii, 2] := 0; // Si no fue menor, 0 puntos

          // --- REGLA 3: NIVEL 2 (Tiene que ser IDÉNTICO) ---
          if puntos_nv2 = val_identico then
               puntos[ii, 3] := puntos_nv2
          else
               puntos[ii, 3] := 0; // Si no le pegó justo, 0 puntos


          // 4. AGREGAMOS LOS RESULTADOS A LA ETIQUETA EN TIEMPO REAL
          lbl_jugvaloralto.caption := lbl_jugvaloralto.caption + #13#10 +
                                      inttostr(ii) + '. ' + nombres[ii] + ' - ' +
                                      'Inicial: ' + inttostr(puntos[ii, 1]) + ' | ' +
                                      'Nivel 1: ' + inttostr(puntos[ii, 2]) + ' | ' +
                                      'Nivel 2: ' + inttostr(puntos[ii, 3]);

          // Avisamos en pantalla qué valores ocultos había para que el alumno sepa si ganó
          showmessage('Resultados de la ronda para ' + nombres[ii] + ':' + #13#10 +
                      'Nivel Inicial (Debía ser > ' + inttostr(val_inicial) + '): Sacó ' + inttostr(puntos[ii, 1]) + ' pts.' + #13#10 +
                      'Nivel 1 (Debía ser < ' + inttostr(val_menor) + '): Sacó ' + inttostr(puntos[ii, 2]) + ' pts.' + #13#10 +
                      'Nivel 2 (Debía ser = ' + inttostr(val_identico) + '): Sacó ' + inttostr(puntos[ii, 3]) + ' pts.');

          // 5. Avanzamos de jugador y limpiamos la pantalla
          ii := ii + 1;
          edt_puntos.text := '';
          edt_puntos_nv1.text := '';
          edt_puntos_nv2.text := '';
     end
     else
          showmessage('El número de jugadores llegó a su límite.');
end;

// 3. NUEVO BOTÓN: PUNTAJE EN LOS NIVELES (Punto a del enunciado)
procedure TForm1.btn_puntos_nivelesClick(Sender: TObject);
var
   pos, j: integer;
   seleccionado: string;
   encontrado: boolean;
begin
     // Validamos que hayan seleccionado un elemento de la lista desplegable
     if cmb_jugadores.ItemIndex = -1 then
     begin
          showmessage('Por favor, seleccione un jugador del ComboBox.');
          exit;
     end;

     seleccionado := cmb_jugadores.Text;
     encontrado := false;
     pos := -1;

     // Buscamos secuencialmente el nombre en nuestro arreglo para saber su índice
     for j := 1 to i - 1 do
     begin
          if nombres[j] = seleccionado then
          begin
               encontrado := true;
               pos := j;
               break;
          end;
     end;

     // Si lo encontramos, extraemos los 3 valores de su fila en la matriz y los mostramos
     if encontrado then
     begin
          showmessage('Puntajes de: ' + nombres[pos] + #13#10 +
                      '===================================' + #13#10 +
                      'Nivel Inicial: ' + inttostr(puntos[pos, 1]) + ' pts' + #13#10 +
                      'Nivel 1: ' + inttostr(puntos[pos, 2]) + ' pts' + #13#10 +
                      'Nivel 2: ' + inttostr(puntos[pos, 3]) + ' pts');
     end;
end;

procedure TForm1.btn_puntos_mayoresClick(Sender: TObject);
var
   j, suma_jugador: integer;
begin
     // Limpiamos el TLabel para mostrar la nueva lista limpia
     lbl_jugmayorvalor.caption := '';

     // Recorremos todos los jugadores que se cargaron hasta ahora
     for j := 1 to i - 1 do
     begin
          // Calculamos el total sumando los 3 niveles de la matriz 2D
          suma_jugador := puntos[j, 1] + puntos[j, 2] + puntos[j, 3];

          // Si el total supera los 100 puntos, lo listamos directamente
          if suma_jugador > 100 then
          begin
               lbl_jugmayorvalor.caption := lbl_jugmayorvalor.caption + #13#10 + nombres[j] + ' - Total: ' + inttostr(suma_jugador) + ' pts.';
          end;
     end;
end;

// 4. INICIALIZACIÓN DEL FORMULARIO
procedure TForm1.FormCreate(Sender: TObject);
var
   f, c: integer;
begin
     // Limpiamos la matriz 2D completa poniendo todas las celdas en cero
     for f := 1 to max do
     begin
          for c := 1 to 3 do
          begin
               puntos[f, c] := 0;
          end;
     end;
end;

end.
