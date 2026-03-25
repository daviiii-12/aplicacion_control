import React, { useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { ChevronDown, FileSignature, CheckCircle2, Moon, Sun, ShieldCheck, AlertCircle } from 'lucide-react';

const clausulas = [
  {
    id: 1,
    titulo: "CLÁUSULA PRIMERA. OBJETO",
    contenido: "EL CONTRATISTA se obliga para con EL CONTRATANTE a desarrollar el entorno interactivo en Unity, la escritura del código C# y la optimización del rendimiento para una experiencia de Realidad Virtual (VR) destinada al lanzamiento de un nuevo producto, por cuenta y riesgo de EL CONTRATANTE, siguiendo estrictamente el plan, guion, modelos 3D y las mecánicas de juego señaladas y suministradas por este."
  },
  {
    id: 2,
    titulo: "CLÁUSULA SEGUNDA. ENTREGABLES",
    contenido: "Al finalizar el desarrollo, EL CONTRATISTA deberá entregar el software ejecutable (.exe) para la feria comercial, así como el código fuente completo, manuales y cualquier otro archivo derivado de la ejecución de este contrato."
  },
  {
    id: 3,
    titulo: "CLÁUSULA TERCERA. HONORARIOS Y VIÁTICOS",
    contenido: "EL CONTRATANTE pagará a EL CONTRATISTA la suma de TRES MILLONES DE PESOS M/CTE ($3.000.000) por la ejecución total de la obra. Este valor incluye los honorarios profesionales y los viáticos necesarios para la asistencia a los encuentros estratégicos y reuniones presenciales."
  },
  {
    id: 4,
    titulo: "CLÁUSULA CUARTA. CESIÓN DE DERECHOS",
    contenido: "EL CONTRATISTA cede a favor de EL CONTRATANTE la totalidad de los derechos patrimoniales sobre el software desarrollado, incluyendo su reproducción, distribución, comunicación pública, transformación, adaptación y explotación comercial."
  },
  {
    id: 5,
    titulo: "CLÁUSULA QUINTA. DERECHOS MORALES",
    contenido: "EL CONTRATANTE reconoce los derechos morales del autor, especialmente el derecho de paternidad e integridad de la obra, conforme a la legislación colombiana."
  },
  {
    id: 6,
    titulo: "CLÁUSULA SEXTA. CONFIDENCIALIDAD",
    contenido: "EL CONTRATISTA se obliga a mantener en estricta reserva y no divulgar a terceros la información técnica, comercial, lógica interna de la marca, guiones, mecánicas de juego ni el código fuente del proyecto. Queda expresamente prohibida la publicación del código fuente en repositorios públicos, plataformas de portafolio o cualquier otro medio."
  },
  {
    id: 7,
    titulo: "CLÁUSULA SÉPTIMA. COMPETENCIA DESLEAL",
    contenido: "EL CONTRATISTA no podrá adaptar, modificar, revender ni licenciar el software desarrollado (ni versiones alteradas del mismo mediante cambios estéticos, de color o de logotipos) a marcas de la competencia ni a ningún tercero."
  },
  {
    id: 8,
    titulo: "CLÁUSULA OCTAVA. SANCIONES",
    contenido: "El incumplimiento de cualquiera de las obligaciones dará lugar a la terminación inmediata del contrato y al cobro de una sanción pecuniaria equivalente a UN MILLÓN DE PESOS M/CTE ($1.000.000), sin perjuicio de las acciones legales correspondientes."
  }
];

export default function App() {
  const [clausulaActiva, setClausulaActiva] = useState(null);
  const [aceptadas, setAceptadas] = useState([]);
  const [contratoFirmado, setContratoFirmado] = useState(false);
  const [modoOscuro, setModoOscuro] = useState(false);

  const progreso = (aceptadas.length / clausulas.length) * 100;
  const todasAceptadas = progreso === 100;

  const toggleClausula = (id) => {
    setClausulaActiva(clausulaActiva === id ? null : id);
  };

  const toggleAceptar = (id, e) => {
    e.stopPropagation();
    if (aceptadas.includes(id)) {
      setAceptadas(aceptadas.filter(item => item !== id));
    } else {
      setAceptadas([...aceptadas, id]);
      setClausulaActiva(null); // Cierra la cláusula al aceptarla
    }
  };

  // Paleta de colores dinámica
  const theme = {
    bg: modoOscuro ? '#0f172a' : '#f8fafc',
    card: modoOscuro ? '#1e293b' : '#ffffff',
    text: modoOscuro ? '#f1f5f9' : '#0f172a',
    textMuted: modoOscuro ? '#94a3b8' : '#64748b',
    border: modoOscuro ? '#334155' : '#e2e8f0',
    primary: '#3b82f6',
    success: '#10b981'
  };

  return (
    <div style={{ fontFamily: 'system-ui, -apple-system, sans-serif', minHeight: '100vh', padding: '2rem 1rem', backgroundColor: theme.bg, color: theme.text, transition: 'all 0.3s ease' }}>
      
      <div style={{ maxWidth: '800px', margin: '0 auto' }}>
        
        {/* Cabecera y botón de tema */}
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '2rem' }}>
          <div>
            <h1 style={{ fontSize: '2.5rem', fontWeight: '800', margin: 0, letterSpacing: '-0.02em' }}>
              Contrato de Servicios
            </h1>
            <p style={{ color: theme.textMuted, margin: '0.5rem 0 0 0', display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
              <AlertCircle size={16} /> Empresa Publicitaria "Ralf"
            </p>
          </div>
          <button 
            onClick={() => setModoOscuro(!modoOscuro)}
            style={{ padding: '0.75rem', borderRadius: '50%', border: `1px solid ${theme.border}`, backgroundColor: theme.card, color: theme.text, cursor: 'pointer', display: 'flex', alignItems: 'center', justifyContent: 'center' }}
          >
            {modoOscuro ? <Sun size={24} /> : <Moon size={24} />}
          </button>
        </div>

        {/* Barra de Progreso */}
        <div style={{ marginBottom: '2rem' }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '0.5rem', fontSize: '0.875rem', color: theme.textMuted, fontWeight: '600' }}>
            <span>Progreso de lectura y aceptación</span>
            <span>{Math.round(progreso)}%</span>
          </div>
          <div style={{ height: '8px', backgroundColor: theme.border, borderRadius: '4px', overflow: 'hidden' }}>
            <motion.div 
              initial={{ width: 0 }}
              animate={{ width: `${progreso}%` }}
              style={{ height: '100%', backgroundColor: todasAceptadas ? theme.success : theme.primary }}
              transition={{ duration: 0.5 }}
            />
          </div>
        </div>

        {/* Contenedor Principal */}
        <AnimatePresence mode="wait">
          {!contratoFirmado ? (
            <motion.div 
              key="contrato"
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              exit={{ opacity: 0, scale: 0.95 }}
              style={{ backgroundColor: theme.card, padding: '2rem', borderRadius: '16px', border: `1px solid ${theme.border}`, boxShadow: modoOscuro ? '0 10px 30px rgba(0,0,0,0.5)' : '0 10px 30px rgba(0,0,0,0.05)' }}
            >
              
              <div style={{ display: 'flex', flexDirection: 'column', gap: '1rem', marginBottom: '3rem' }}>
                {clausulas.map((clausula) => {
                  const estaAceptada = aceptadas.includes(clausula.id);
                  const estaActiva = clausulaActiva === clausula.id;

                  return (
                    <div key={clausula.id} style={{ border: `1px solid ${estaAceptada ? theme.success : theme.border}`, borderRadius: '12px', overflow: 'hidden', transition: 'all 0.2s' }}>
                      
                      <button
                        onClick={() => toggleClausula(clausula.id)}
                        style={{ width: '100%', padding: '1.25rem', display: 'flex', justifyContent: 'space-between', alignItems: 'center', backgroundColor: estaActiva ? (modoOscuro ? '#1e293b' : '#f8fafc') : 'transparent', border: 'none', cursor: 'pointer', color: theme.text, textAlign: 'left' }}
                      >
                        <div style={{ display: 'flex', alignItems: 'center', gap: '1rem' }}>
                          <div 
                            onClick={(e) => toggleAceptar(clausula.id, e)}
                            style={{ width: '24px', height: '24px', borderRadius: '6px', border: `2px solid ${estaAceptada ? theme.success : theme.textMuted}`, display: 'flex', alignItems: 'center', justifyContent: 'center', cursor: 'pointer', backgroundColor: estaAceptada ? theme.success : 'transparent' }}
                          >
                            {estaAceptada && <CheckCircle2 size={16} color="white" />}
                          </div>
                          <span style={{ fontWeight: '600', fontSize: '1rem', textDecoration: estaAceptada ? 'line-through' : 'none', opacity: estaAceptada ? 0.6 : 1 }}>
                            {clausula.titulo}
                          </span>
                        </div>
                        <motion.div animate={{ rotate: estaActiva ? 180 : 0 }}>
                          <ChevronDown size={20} color={theme.textMuted} />
                        </motion.div>
                      </button>

                      <AnimatePresence>
                        {estaActiva && (
                          <motion.div
                            initial={{ height: 0, opacity: 0 }}
                            animate={{ height: 'auto', opacity: 1 }}
                            exit={{ height: 0, opacity: 0 }}
                          >
                            <div style={{ padding: '0 1.25rem 1.25rem 3.75rem', color: theme.textMuted, lineHeight: '1.7' }}>
                              {clausula.contenido}
                            </div>
                          </motion.div>
                        )}
                      </AnimatePresence>

                    </div>
                  );
                })}
              </div>

              {/* Botón Final */}
              <div style={{ textAlign: 'center' }}>
                <button 
                  onClick={() => setContratoFirmado(true)}
                  disabled={!todasAceptadas}
                  style={{ backgroundColor: todasAceptadas ? theme.primary : theme.border, color: todasAceptadas ? 'white' : theme.textMuted, padding: '1rem 3rem', borderRadius: '50px', border: 'none', fontSize: '1.125rem', fontWeight: 'bold', cursor: todasAceptadas ? 'pointer' : 'not-allowed', display: 'inline-flex', alignItems: 'center', gap: '0.75rem', transition: 'all 0.3s' }}
                >
                  <FileSignature size={24} />
                  {todasAceptadas ? 'Firmar y Proteger Derechos' : 'Acepta todas las cláusulas para firmar'}
                </button>
              </div>

            </motion.div>
          ) : (
            <motion.div 
              key="exito"
              initial={{ scale: 0.8, opacity: 0 }}
              animate={{ scale: 1, opacity: 1 }}
              style={{ backgroundColor: theme.card, padding: '4rem 2rem', borderRadius: '16px', border: `1px solid ${theme.success}`, textAlign: 'center', boxShadow: `0 20px 40px ${modoOscuro ? 'rgba(16,185,129,0.1)' : 'rgba(16,185,129,0.2)'}` }}
            >
              <motion.div 
                initial={{ scale: 0 }}
                animate={{ scale: 1, rotate: [0, 10, -10, 0] }}
                transition={{ type: "spring", stiffness: 200, damping: 10 }}
                style={{ width: '80px', height: '80px', backgroundColor: theme.success, borderRadius: '50%', display: 'flex', alignItems: 'center', justifyContent: 'center', margin: '0 auto 1.5rem auto' }}
              >
                <ShieldCheck size={40} color="white" />
              </motion.div>
              <h2 style={{ fontSize: '2.5rem', fontWeight: '800', margin: '0 0 1rem 0', color: theme.text }}>Derechos Asegurados</h2>
              <p style={{ fontSize: '1.125rem', color: theme.textMuted, maxWidth: '500px', margin: '0 auto' }}>
                La Empresa Publicitaria "Ralf" ha consolidado legalmente la cesión de derechos patrimoniales y el acuerdo de confidencialidad de la obra interactiva en Unity.
              </p>
            </motion.div>
          )}
        </AnimatePresence>
        
      </div>
    </div>
  );
}