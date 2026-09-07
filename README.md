# Taller-Alupro.io
flujo de gestion y optimización de un taller de ventanas 
Taller Aluminio App - Estructura Completa Repositorio
Basado en Catálogos Conalum Validados - Tlaquepaque Jalisco
Escalable sin fricción - Multi-sucursal y Multi-taller

Estructura de Directorios
taller-aluminio-app/
├── README.md
├── contexto.md                          # Contexto validado Conalum + formulas
├── schema.sql                           # Esquema base escalable
├── schema_conalum.sql                   # Inserts Conalum Corrediza 3" y Finestra 1400
├── requirements.txt                     # Python deps
├── .env.example
│
├── backend/
│   ├── app.py                           # FastAPI main
│   ├── models/
│   │   ├── series.py
│   │   ├── perfiles.py
│   │   ├── formulas.py                  # Motor evalua formulas W, H-40, (W+25)/2-45
│   │   ├── cotizaciones.py
│   │   ├── inventario.py
│   │   └── ordenes.py
│   ├── services/
│   │   ├── motor_despiece.py            # script_motor_conalum.py
│   │   ├── motor_croquis.py             # Generador 2D paramétrico
│   │   ├── motor_precio.py              # Calculo costo_ml + vidrio + margen
│   │   ├── motor_compras.py             # Faltante y tramos 6.1m
│   │   └── pdf_generator.py             # Cotización con croquis
│   ├── api/
│   │   ├── cotizaciones.py
│   │   ├── despiece.py
│   │   ├── inventario.py
│   │   └── croquis.py
│   └── tests/
│       ├── test_despiece.py
│       ├── test_precio_compras.py
│       ├── test_conalum.py
│       └── test_croquis.py
│
├── frontend-mobile/
│   ├── src/
│   │   ├── App.jsx                      # App móvil 5 pantallas (artifact)
│   │   ├── screens/
│   │   │   ├── CotizacionScreen.jsx     # Pantalla 1 - Captura W/H/Serie
│   │   │   ├── DespieceScreen.jsx       # Pantalla 2 - Lista cortes Conalum
│   │   │   ├── CroquisScreen.jsx        # Pantalla 3 - SVG paramétrico real
│   │   │   ├── ComprasScreen.jsx        # Pantalla 4 - Stock y faltantes
│   │   │   └── OrdenScreen.jsx          # Pantalla 5 - Resumen + WhatsApp
│   │   ├── components/
│   │   │   ├── CroquisCanvas.jsx        # Canvas SVG 2D motor
│   │   │   ├── PerfilCard.jsx
│   │   │   ├── MedidaInput.jsx
│   │   │   └── TabBar.jsx               # Navegación inferior
│   │   ├── hooks/
│   │   │   ├── useDespiece.js           # Hook motor despiece Conalum
│   │   │   └── useCroquis.js
│   │   └── services/
│   │       └── api.js
│   ├── public/
│   └── package.json
│
├── assets/
│   ├── croquis/
│   │   ├── croquis_150x120.png
│   │   ├── croquis_60x40.png
│   │   └── croquis_200x150.png
│   └── catalogos/
│       ├── CONALUM-CATALOGO-2021.pdf
│       └── Cuprum-Panorama-2021.pdf
│
└── scripts/
    ├── seed_conalum.py                  # Carga inicial Conalum
    └── optimizar_cortes.py              # Bin packing tramos 6.1m
Flujo Escalable sin Fricción
Cotización (W, H, serie Conalum) ->
Motor despiece lee formulas_descuento (W, H-20, (W+25)/2-45) sin ifs ->
Motor croquis genera SVG 2D real con medidas ->
Motor precio calcula ml * costo + m2 vidrio + mano obra + margen ->
Motor compras compara necesario vs inventario sucursal -> tramos 6.1m ->
Orden trabajo + PDF con croquis para WhatsApp
Tablas Clave (14 tablas)
talleres, sucursales, series (Finestra 1400, Corrediza 3", Fijo 3"), perfiles (CON-3-RielSup etc), formulas_descuento, accesorios, accesorios_por_serie, clientes, cotizaciones, cotizacion_detalle, despiece_calculado, despiece_vidrio, inventario, lista_compras, ordenes_trabajo, instalaciones

Validación
Catálogo Conalum 2021: Perfiles Corrediza 3", Fijo 3", Finestra 1400
Matriz Conalum: Hacienda La Calerilla 126, Tlaquepaque Jal
50+ sucursales nacionales
Fórmulas validadas: H-40, L-40, H-146, L/2-28, H-99, L/2-116 (Serie 1400 oficial)
Tests: 5 despiece + 5 precio/compras + 3 Conalum + 4 croquis = 17 tests en verde
Cómo iniciar
bash
git clone ...
pip install -r requirements.txt
psql -f schema.sql
psql -f schema_conalum.sql
pytest backend/tests/
cd frontend-mobile && npm install && npm run dev
Próximos pasos escalables
Agregar Serie 3500, Línea Española solo insertando en series/perfiles/formulas