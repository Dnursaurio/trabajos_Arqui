//inclusiones 
#include <iostream>
#include <cstdint>
#include <bitset>
#include <iomanip>
using namespace std;

/*usaremos un numero para almancenar 
el exponente como un numero sin signo*/
const int BIAS = 127;

/*ahora descomponemos los valores flotantes en bits
1 bit para el signo, 8 para la parte entera y 23 para 
la flotante*/
void Bitfloat(float numerico, uint32_t &signo, uint32_t &exponente, uint32_t &significando)
{
	//aqui se interpreta los valores float como un entero de 32 bits
	uint32_t bits;
	//esto copiara el valor de float en la variable de "bits" 
	memcpy(&bits,&numerico,sizeof(numerico));

	//ahora obetenemos el bit del signo
	signo = (bits >> 31) & 0x1;

	//aqui los 8 bits del exponente
	exponente = (bits >> 23) & 0xFF;

	//finalmente los 23 bits del significando
	significando = bits & 0x7FFFFF;
}

//ahora verificamos si alguno de los valores ingresados es 0
bool ValorCero(float numerico)
{
	uint32_t bits;
	memcpy(&bits, &numerico, sizeof(numerico));

	//segun el formato IEEE754, un valor es 0 cuando el exponente es 0 y el significando es 0
	uint32_t exp = (bits >> 23) & 0xFF;
	uint32_t sig = bits & 0x7FFFFF;

	return (exp == 0 && sig == 0);
}

//realizmos una verficacio0n de los bits para poder evitar margen de error durante la operacion
void Verificacion(float valor)
{
	uint32_t bits;
	memcpy(&bits, &valor, sizeof(valor));

	uint32_t signo = (bits >> 31) & 0x1;
	uint32_t exponente = (bits >> 23) & 0xFF;
	uint32_t significando = bits & 0x7FFFFF;

	cout << "\nValor entero: " << valor << endl;
	cout << "Bits: " << bitset<32>(bits) << endl;
	cout << "Signo: " << signo << endl;
	cout << "Exponente: " << bitset<8>(exponente) << " (" << exponente - BIAS << ")" << endl;
	cout << "Significando: " << bitset<23>(significando) << endl;
}

int main()
{
	//establecemos 3 numeros en punyto flotante
	float numero1, numero2;
	
	//introducimos el valor 1
	cout << "ingrese un numero en punto flotante: ";
	cin >> numero1;

	//introducimos el valor 2
	cout << "ingrese otro numero en punto flotante: ";
	cin >> numero2;

	Verificacion(numero1);
	Verificacion(numero2);

	//aqui hacemos el chequeo del valor 0
	if (ValorCero(numero1) || ValorCero(numero2))
	{
		cout << "El resultado de una multiplicación por 0 es 0 ._." << endl;
	}
	else
	{
		//descomponemos los numeros
		uint32_t signo1, exp1, significando1;
		uint32_t signo2, exp2, significando2;
		//imprimimos los bit separados
		Bitfloat(numero1,signo1, exp1, significando1);
		Bitfloat(numero2, signo2, exp2, significando2);

		cout << "\nPrimer valor descompuesto: " << endl;
		cout << "Signo: " << signo1 << " Exponente: " << bitset<8>(exp1) << " Significando: " << bitset<23>(significando1) << endl;
		cout << "\nSegundo valor descompuesto: " << endl;
		cout << "Signo: " << signo2 << " Exponente: " << bitset<8>(exp2) << " Significando: " << bitset<23>(significando2) << endl;
		//realizamos la suma binaria de los exponentes
		

		int sumaexp = (exp1 - BIAS) + (exp2 - BIAS) + BIAS;

		//realizamos la verficiacion de overflow o underflow de ser el caso
		if (sumaexp >= 255)
		{
			cout << "\nHubo Overflow, exponenete grande" << endl;
			return 0;
		}
		else if (sumaexp <= 0)
		{
			cout << "\nHubo Underflow, exponente pequeño";
			return 0;
		}
		else
		{
			//aqui realizaremos la muliplicacion de significandos
			double significandoreal1 = 1.0 + (significando1 / static_cast<double>(0x800000));
			double significandoreal2 = 1.0 + (significando2 / static_cast<double>(0x800000));

			double significandorpta = significandoreal1 * significandoreal2;

			//aqui hacemos el redondeo  del numero caso que revalse en 0.9 + 0.1
			if (significandorpta >= 2.0)
			{
				significandorpta /= 2.0;
				sumaexp += 1;
			}

			//impresion de resultados
			cout << fixed << setprecision(7);
			cout << "\nResultados de la multiplicacion de significandos: " << bitset<23>(significandorpta) << endl;
			cout << "\nExponente redondeado: " << bitset<8>(sumaexp) << endl;

			uint32_t significandoend = (significandorpta - 1.0) * (0x800000);

			uint32_t signorpta = signo1 ^ signo2;

			uint32_t rptabits = (signorpta << 31) | (sumaexp << 23) | (significandoend & 0x7FFFFF);

			float respuesta;
			memcpy(&respuesta,&rptabits, sizeof(respuesta));

			//respuesta definitiva
			cout << "\nRespuesta en bits: " << bitset<32>(respuesta)<< endl;
			cout << "Resultado final en flotante: " << fixed << setprecision(7) << respuesta << endl;
		}
	}
	
	return 0;
}