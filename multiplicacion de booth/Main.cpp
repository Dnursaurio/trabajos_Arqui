#include <bitset>
#include<iostream>
#include<string>
using namespace std;

int main()
{
	//multiplicando
	//multiplicados
	bitset<8> A(0);
	//acarreo
	bitset<1> Qo;

	/*le pedimos al usuario que ingrese dos 
	numeros cada uno de 8 bits, tento en el multuplicando
	como en el multiplicador*/

	//ingresamos un multiplicando
	cout << "ingrese un multpiplicando: ";
	string multiplicando;
	cin >> multiplicando;
	int multiplicando_int = stoi(multiplicando);
	bitset<8>M(multiplicando_int);

	//ahora lo mismo para el mulltiplicador
	cout << "ingrese un multiplicador: ";
	string multiplicador;
	cin >> multiplicador;
	int multiplicador_int = stoi(multiplicador);
	bitset<8>Q(multiplicador_int);
	//ahora seteamos los valor que Q y Qo para la condicional de 10 y 01
	// Setear Qo al bit menos significativo de Q
	Q[0] = Q[0];

	//cremoas un contador n
	int n = 8;

	//realizamos la multiplicacion de Booth
	while (n > 0)
	{
		/*verificamos los casos del 01 y 10 con Q y Qo
		en caos de que Q = y Qo = 0 entonces A = A - M 
		o si Q = 0 y Qo = 1 entonces A = A + M*/
		if (Q[7] == 1 && Qo[0] == 0) {
			A = bitset<8>(A.to_ulong() - M.to_ulong()); // A = A - M
		}
		else if (Q[7] == 0 && Qo[0] == 1) 
		{
			A = bitset<8>(A.to_ulong() + M.to_ulong()); // A = A + M
		}
		//Realizamos desplazamiento a la derecha
		Qo[0] = Q[0];  // Qo toma el bit menos significativo de Q
		Q >>= 1;       // Desplazar Q hacia la derecha
		Q[7] = A[0];   // El bit más significativo de Q toma el primer bit de A
		A >>= 1;       // Desplazar A hacia la derecha
		cout << "A: " << A << " Q: " << Q << " Qo: " << Qo<<endl;
		n--;
	}
	cout << "el resultado por multiplicación de Booth es :" << A << Q << Qo << M << endl;
	return 0;
}