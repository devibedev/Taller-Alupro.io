# backend/tests/test_despiece.py
import pytest
import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from script_motor_conalum import calcular_despiece

def test_despiece_corrediza_1500x1200():
    """Test medidas estándar 1500x1200"""
    resultado = calcular_despiece(1500, 1200, 1)
    assert resultado['vidrio']['m2'] == pytest.approx(1.56, rel=0.1)
    assert len(resultado['cortes']) == 7

def test_despiece_formula_riel():
    """Riel debe ser igual al ancho"""
    resultado = calcular_despiece(1500, 1200, 1)
    riel_sup = [c for c in resultado['cortes'] if c['clave'] == 'CR-301'][0]
    assert riel_sup['medida_mm'] == 1500

def test_despiece_formula_jamba():
    """Jamba debe ser igual al alto"""
    resultado = calcular_despiece(1500, 1200, 1)
    jamba = [c for c in resultado['cortes'] if c['clave'] == 'CR-303'][0]
    assert jamba['medida_mm'] == 1200

def test_despiece_formula_cerco():
    """Cerco = H-20"""
    resultado = calcular_despiece(1500, 1200, 1)
    cerco = [c for c in resultado['cortes'] if c['clave'] == 'CR-304'][0]
    assert cerco['medida_mm'] == 1180

def test_despiece_formula_zoclo():
    """Zoclo = (W+25)/2-45"""
    resultado = calcular_despiece(1500, 1200, 1)
    zoclo = [c for c in resultado['cortes'] if c['clave'] == 'CR-306'][0]
    assert zoclo['medida_mm'] == (1500+25)/2-45
