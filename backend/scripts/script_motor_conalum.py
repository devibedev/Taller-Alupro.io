#!/usr/bin/env python3
"""
Motor de despiece paramétrico Conalum
Lee fórmulas de la base de datos (o de un diccionario en memoria para pruebas)
Entrada: ancho_mm, alto_mm, serie_id
Salida: diccionario con cortes, vidrio, accesorios
"""
import re
import sys
from typing import Dict, List, Union, Tuple

# Datos simulados de BD (en producción se consultará PostgreSQL)
PERFILES_DB = {
    1: [  # Corrediza 3"
        {"id": 1, "clave": "CR-301", "nombre": "Riel Superior", "formula": "W", "cantidad": 1},
        {"id": 2, "clave": "CR-302", "nombre": "Riel Inferior", "formula": "W", "cantidad": 1},
        {"id": 3, "clave": "CR-303", "nombre": "Jamba", "formula": "H", "cantidad": 2},
        {"id": 4, "clave": "CR-304", "nombre": "Cerco", "formula": "H-20", "cantidad": 2},
        {"id": 5, "clave": "CR-305", "nombre": "Traslape", "formula": "H-20", "cantidad": 2},
        {"id": 6, "clave": "CR-306", "nombre": "Zoclo", "formula": "(W+25)/2-45", "cantidad": 2},
        {"id": 7, "clave": "CR-307", "nombre": "Cabezal", "formula": "(W+25)/2-45", "cantidad": 2},
    ],
    # Añadir más series según catálogo
}

def evaluar_formula(formula: str, W: float, H: float) -> float:
    """
    Evalúa una fórmula matemática segura con variables W y H.
    Solo permite números, operadores + - * /, paréntesis y variables W, H.
    """
    # Validar que solo contenga caracteres permitidos
    if not re.match(r'^[\d\s\+\-\*/\(\)WH\.]+$', formula):
        raise ValueError(f"Fórmula inválida: {formula}")
    
    # Reemplazar variables
    formula_replaced = formula.replace('W', str(W)).replace('H', str(H))
    
    # Evaluar de forma segura (evitando eval directo, pero aquí es controlado)
    # Usamos eval con un entorno restringido
    try:
        result = eval(formula_replaced, {"__builtins__": {}}, {})
        return float(result)
    except Exception as e:
        raise ValueError(f"Error evaluando fórmula '{formula}': {e}")

def calcular_despiece(ancho_mm: int, alto_mm: int, serie_id: int) -> Dict:
    """
    Calcula el despiece completo para una ventana.
    """
    if ancho_mm <= 0 or alto_mm <= 0:
        raise ValueError("Ancho y alto deben ser positivos")
    
    perfiles = PERFILES_DB.get(serie_id)
    if not perfiles:
        raise ValueError(f"Serie {serie_id} no encontrada")
    
    cortes = []
    for perfil in perfiles:
        medida = evaluar_formula(perfil['formula'], ancho_mm, alto_mm)
        # Redondear a 1 decimal
        medida = round(medida, 1)
        cortes.append({
            'perfil_id': perfil['id'],
            'clave': perfil['clave'],
            'nombre': perfil['nombre'],
            'medida_mm': medida,
            'cantidad': perfil['cantidad']
        })
    
    # Cálculo de vidrio (para corrediza 3" estándar)
    # Zoclo = (W+25)/2-45 -> ancho hoja = zoclo - 35 holgura
    # Cerco = H-20 -> alto hoja = cerco - 35 holgura
    zoclo = evaluar_formula('(W+25)/2-45', ancho_mm, alto_mm)
    cerco = evaluar_formula('H-20', ancho_mm, alto_mm)
    ancho_vidrio = zoclo - 35
    alto_vidrio = cerco - 35
    cantidad_vidrio = 2  # dos hojas
    m2_vidrio = (ancho_vidrio * alto_vidrio * cantidad_vidrio) / 1_000_000
    
    vidrio = {
        'ancho_mm': round(ancho_vidrio, 1),
        'alto_mm': round(alto_vidrio, 1),
        'cantidad': cantidad_vidrio,
        'm2': round(m2_vidrio, 3)
    }
    
    # Accesorios (simplificado para serie 1)
    accesorios = [
        {"nombre": "Jaladera", "cantidad": 2},
        {"nombre": "Rueda", "cantidad": 4},
        {"nombre": "Felpa", "cantidad": 4},
        {"nombre": "Tornillo", "cantidad": 20},
        {"nombre": "Silicon", "cantidad": 1},
    ]
    
    return {
        'cortes': cortes,
        'vidrio': vidrio,
        'accesorios': accesorios
    }

if __name__ == "__main__":
    if len(sys.argv) == 4:
        w = int(sys.argv[1])
        h = int(sys.argv[2])
        serie = int(sys.argv[3])
        resultado = calcular_despiece(w, h, serie)
        import json
        print(json.dumps(resultado, indent=2))
    else:
        print("Uso: python script_motor_conalum.py <ancho_mm> <alto_mm> <serie_id>")
