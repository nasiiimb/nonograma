🧠 Nonograma-Prolog  
Nonograma-Prolog es una implementación del popular rompecabezas lógico nonograma, desarrollada en **Prolog** como práctica final de la asignatura _Lenguajes de Programación_ del Grado de Ingeniería Informática en la **Universitat de les Illes Balears (UIB)** durante el curso 2024–2025.

Este proyecto permite tanto verificar soluciones como generar nonogramas aleatorios y representarlos visualmente en consola.

📂 Estructura del Proyecto  
El archivo principal `nonograma.pl` incluye todos los predicados necesarios organizados en bloques funcionales:

- `nonograma/3`: Verifica si una solución dada cumple las pistas de filas y columnas.
- `genera_nonograma/5`: Genera una solución aleatoria y sus pistas correspondientes.
- `pinta_nonograma/1`: Muestra la cuadrícula en formato ASCII.
- Predicados auxiliares: `fila_ok`, `trasponer`, `bits_aleatorios`, `pistas_filas`, etc.

🛠️ Requisitos  
Para ejecutar este proyecto necesitarás:

- Un entorno de ejecución de **Prolog** (como SWI-Prolog).
- Conocimientos básicos de programación lógica y listas en Prolog.

🚀 Funcionalidades  
El sistema implementa:

- ✔️ Verificación de nonogramas dados.
- ✔️ Generación aleatoria de puzzles rectangulares (tamaño F×C).
- ✔️ Representación visual de la cuadrícula.
- ✔️ Soporte de puzzles no cuadrados.
- ✔️ Lógica 100% declarativa, sin cortes innecesarios.

🧪 Ejemplos de Uso  
```prolog
?- nonograma(
       [[5], [], [2,1], [1], [1,2]],
       [[1,1],[1,1],[1,1,1],[1,2],[1,1]],
       Casillas).
Casillas = [[1,1,1,1,1],
            [0,0,0,0,0],
            [0,1,1,0,1],
            [0,0,0,1,0],
            [1,0,1,1,0]].

?- genera_nonograma(5,7,PistasFilas,PistasCols,Solucion),
   pinta_nonograma(Solucion).
