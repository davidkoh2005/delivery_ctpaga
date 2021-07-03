import 'package:flutter/material.dart';

//TODO: Url Api (LocalHost)
//String url = "192.168.1.116:8000";

//TODO: Url Api (AWS)
//String url = "54.196.181.42";

//TODO: Url Api (hosting)
String url = "ctpaga.app";

String urlApi = "http://$url/api/auth/";

Color colorLogo = Color.fromRGBO(0,204,96,1); //color green
//Color colorLogo = Color.fromRGBO(238,93,21,1); //color orange
Color colorGrey = Color.fromRGBO(182,182,182,1);
Color colorGreyLogo = Color.fromRGBO(69, 69, 94, 1);
Color colorGreyOpacity = Color.fromRGBO(230,230,230,1);
Color colorText = Colors.grey;




List listColors = [
  {  
    "name": "Aceituna",
    "hex": "#808000",
  },
  {  
    "name": "Agua",
    "hex": "#00FFFF",
  },
  {  
    "name": "Aguamarina",	
    "hex": "#7FFFD4",
  },
  {  
    "name": "Almendra blanqueada",
    "hex": "#FFEBCD",
  },
  {  
    "name": "Amarillo",
    "hex": "#FFFF00",
  },	
  {  
    "name": "Amarillo claro",	
    "hex": "#FFFFE0",
  }, 
  {  
    "name": "Amarillo verdes",	
    "hex": "#9ACD32",
  },
  {  
    "name": "Armada",
    "hex": "#000080",
  },
  {  
    "name": "Azul",
    "hex": "#0000FF",
  },	
  {  
    "name": "Azul alicia",	
    "hex": "#F0F8FF",
  },
  {  
    "name": "Azul acero",	
    "hex": "#4682B4",
  },
  {  
    "name": "Azul aciano",
    "hex": "#6495ED",
  },
  {  
    "name": "Azul cadete",	
    "hex": "#5F9EA0",
  },
  {  
    "name": "Azul claro",	
    "hex": "#ADD8E6",
  },
  {  
    "name": "Azul claro acero",	
    "hex": "#B0C4DE",
  },
  {  
    "name": "Azul cielo",	
    "hex": "#87CEEB",
  },
  {  
    "name": "Azul cielo claro",	
    "hex": "#87CEFA",
  },
  {  
    "name": "Azul cielo profundo",
    "hex": "#00BFFF",
  },	 
  {  
    "name": "Azul dodger",	
    "hex": "#1E90FF",
  },
  {  
    "name": "Azul medianoche",	
    "hex": "#191970",
  },
  {  
    "name": "Azul medio", 
    "hex": "#0000CD",
  },
  {  
    "name": "Azul medio Pizarra",	
    "hex": "#7B68EE",
  },
  {  
    "name": "Azul oscuro",
    "hex": "#00008B",
  },
  {  
    "name": "Azul oscuro pizarra",
    "hex": "#483D8B",
  },
  {  
    "name": "Azul Pálido",
    "hex": "#B0E0E6",
  },
  {  
    "name": "Azul pizarra",	
    "hex": "#6A5ACD",
  },
  {  
    "name": "Azul real",	
    "hex": "#4169E1",
  },
  {  
    "name": "Azur",
    "hex": "#F0FFFF",
  }, 
  {  
    "name": "Beige",	
    "hex": "#F5F5DC",
  },
  {  
    "name": "Blanco",	
    "hex": "#FFFFFF",
  },
  {  
    "name": "Blanco antiguo",	
    "hex": "#FAEBD7",
  },	 	 	 	 
  {  
    "name": "Blanco fantasma",
    "hex": "#F8F8FF",
  },
  {  
    "name": "Blanco floral",	
    "hex": "#FFFAF0",
  },	 
  {  
    "name": "Blanca navajo",
    "hex": "#FFDEAD",
  },
  {  
    "name": "caqui",	
    "hex": "#F0E68C",
  },
  {  
    "name": "Caqui oscuro",	
    "hex": "#BDB76B",
  },	 
  {  
    "name": "Cardo",
    "hex": "#D8BFD8",
  },
  {  
    "name": "Carmesí",
    "hex": "#DC143C",
  },
  {  
    "name": "Chocolate",
    "hex": "#D2691E",
  },	 
  {  
    "name": "Cian",
    "hex": "#00FFFF",
  },	 	 
  {  
    "name": "Cian claro",
    "hex": "#E0FFFF",
  },
  {  
    "name": "Cian oscuro",
    "hex": "#008B8B",
  },	 
  {  
    "name": "Ciruela",
    "hex": "#DDA0DD",
  },
  {  
    "name": "Coral",
    "hex": "#FF7F50",
  },
  {  
    "name": "Coral claro",
    "hex": "#F08080",
  },
  {  
    "name": "Crema de menta",	
    "hex": "#F5FFFA",
  },
  {  
    "name": "Dorado claro",
    "hex": "#FAFAD2",
  },
  {  
    "name": "Fucsia",
    "hex": "#FF00FF",
  },	
  {  
    "name": "Gasa de limón",
    "hex": "#FFFACD",
  }, 
  {  
    "name": "Gotas de miel",	
    "hex": "#F0FFF0",
  }, 
  {	 
    "name":"Gris",
    "hex"	: "#808080",
  },
   {  
    "name": "Gris claro",	
    "hex": "#D3D3D3",
  },
  {  
    "name": "Gris oscuro",
    "hex": "#A9A9A9",
  },	 
  {  
    "name": "Gris oscuro pizarra ",
    "hex": "#2F4F4F",
  },
  {  
    "name": "Gris Oscuro tardío", 
    "hex": "#2F4F4F",
  },
  {  
    "name": "Gris pizarra",	
    "hex": "#708090",
  },
  {  
    "name": "Índigo",
    "hex": "#4B0082",
  },
  {  
    "name": "Indio rojo",
    "hex": "#CD5C5C",
  },	 
  {  
    "name": "Ladrillo refractario",
    "hex": "#B22222",
  },
  {  
    "name": "Látigo de papaya",	
    "hex": "#FFEFD5",
  },	
  {  
    "name": "Lavanda",	
    "hex": "#E6E6FA",
  },	 
  {  
    "name": "Lavanda rubor",
    "hex": "#FFF0F5",
  },
  {  
    "name": "Lima", 
    "hex": "#00FF00",
  },
  {  
    "name": "Lino",	
    "hex": "#FAF0E6",
  },
  {  
    "name": "Madera corpulenta",	
    "hex": "#DEB887",
  },
  {  
    "name": "Magenta",
    "hex": "#FF00FF",
  },	 	 
  {  
    "name": "Magenta oscura",
    "hex": "#8B008B",
  },
  {  
    "name": "Mar verdes",
    "hex": "#2E8B57",
  },
  {  
    "name": "Marfil",
    "hex": "#FFFFF0",
  },
  {  
    "name": "Marrón",
    "hex": "#A52A2A",
  },
  {  
    "name": "Marrón claro",
    "hex": "#FFE4C4",
  },
  {  
    "name": "Marrón rosado",
    "hex": "#BC8F8F",
  },	 
  {  
    "name": "Marrón arenoso",	
    "hex": "#F4A460",
  },	 
  {  
    "name": "Melocotón",
    "hex": "#FFDAB9",
  },
  {  
    "name": "mocasín",
    "hex": "#FFE4B5",
  },
  {  
    "name": "Monasterio",
    "hex": "#7FFF00",
  },
  {  
    "name": "Morado medio",
    "hex": "#9370D8",
  },
  {  
    "name": "Naranja",
    "hex": "#FFA500",
  },	
  {  
    "name": "Naranja oscuro",
    "hex": "#FF8C00",
  },
  {  
    "name": "Negro",
    "hex": "#000000",
  },
  {  
    "name": "Nieve",	
    "hex": "#FFFAFA",
  },
  {  
    "name": "Oro",
    "hex": "#FFD700",
  },
  {  
    "name": "Orquídea ",
    "hex": "#DA70D6",
  },
  {  
    "name": "Orquídea oscura",	
    "hex": "#9932CC",
  }, 
  {  
    "name": "Orquídea mediana",	
    "hex": "#BA55D3",
  }, 
  {  
    "name": "Plata",
    "hex": "#C0C0C0",
  },	 
  {  
    "name": "Primaveral medio",
    "hex": "#00FA9A",
  },
    {  
    "name": "Púrpura",
    "hex": "#800080",
  },
  {  
    "name": "Rojo", 
    "hex": "#FF0000",
  },	 	 		
  {  
    "name": "Rojo naranja",
    "hex": "#FF4500",
  },
  {  
    "name": "Rojo oscuro", 
    "hex": "#8B0000",
  },
  {  
    "name": "Rosa",
    "hex": "#FFC0CB",
  }, 
  {  
    "name": "Rosa brumosa",
    "hex": "#FFE4E1",
  },	
  {  
    "name": "Rosa caliente",	
    "hex": "#FF69B4",
  },
  {  
    "name": "Rosa claro",	
    "hex": "#FFB6C1",
  },
  {  
    "name": "Rosa profundo",	
    "hex": "#FF1493",
  },
  {  
    "name": "Salmón",	
    "hex": "#FA8072",
  },
  {  
    "name": "Salmón ligero",	
    "hex": "#FFA07A",
  },
  {  
    "name": "Salmón oscuro",	
    "hex": "#E9967A",
  },
  {  
    "name": "Seda de maiz",
    "hex": "#FFF8DC",
  },
  {  
    "name": "tan",
    "hex": "#D2B48C",
  },	 	 
  {  
    "name": "Tomate",
    "hex": "#FF6347",
  },	 
  {  
    "name": "Turquesa",	
    "hex": "#40E0D0",
  },
  {  
    "name": "Turquesa medio",	
    "hex": "#48D1CC",
  },
  {  
    "name": "Turquesa oscuro",
    "hex": "#00CED1",
  },
  {  
    "name": "Turquesa pálido",
    "hex": "#AFEEEE",
  },
  {  
    "name": "Trigo",	
    "hex": "#F5DEB3",
  },
  {  
    "name": "Vara de oro",	
    "hex": "#DAA520",
  },
  {  
    "name": "Varilla de oro oscura",	
    "hex": "#B8860B",
  }, 	
  {  
    "name": "Varilla de oro pálido",
    "hex": "#EEE8AA",
  },
  {
    "name":"verdes",
    "hex"	: "#008000",
  },
  {  
    "name": "verdes amarillo",	
    "hex": "#ADFF2F",
  },	 	 	 	 	 
  {  
    "name": "verdes azulado",
    "hex": "#008080",
  },		 	 
  {  
    "name": "verdes bosque",
    "hex": "#228B22",
  },
  {  
    "name": "verdes césped",
    "hex": "#7CFC00",
  },	 	 	 	 	 
  {  
    "name": "verdes claro",	
    "hex": "#90EE90",
  },
  {  
    "name": "verdes lima",
    "hex": "#32CD32",
  },	 	 	 	 
  {  
    "name": "verdes mar claro",	
    "hex": "#20B2AA",
  },	 	 	 	 	 	 	 	 	 	 	 	 	
  {  
    "name": "verdes mar oscuro",	
    "hex": "#8FBC8F",
  }, 	 	
  {  
    "name": "verdes medio",	
    "hex": "#3CB371",
  }, 	
  {  
    "name": "verdes oliva",	
    "hex": "#6B8E23",
  }, 	 	  	 	 
  {  
    "name": "verdes oliva oscuro",
    "hex": "#556B2F",
  },	 	 	 	 	 
  {  
    "name": "verdes oscuro",
    "hex": "#006400",
  }, 	 
  {  
    "name": "verdes pálido",
    "hex": "#98FB98",
  },	 
  {  
    "name": "verdes primavera",
    "hex": "#00FF7F",
  }, 	 	 	 
  {  
    "name": "Violeta",	
    "hex": "#EE82EE",
  },
  {  
    "name": "Violeta oscuro",
    "hex": "#9400D3",
  },	 	 	  	 
  {  
    "name": "Violeta azul",	
    "hex": "#8A2BE2",
  },		 	 	  	 	 	 
  {  
    "name": "Violeta medio",	
    "hex": "#C71585",
  },	 	  		 	 	   	 	 
  {  
    "name": "Violeta pálido",	
    "hex": "#D87093",
  },	  	 	 	 	 	 	   	  	 	 	   	 	 	  	 	  
];