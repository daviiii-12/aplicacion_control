import React, { useState, useRef, useEffect } from 'react';
import { motion, AnimatePresence, useMotionValue, useTransform } from 'framer-motion';
import { ChevronDown, FileSignature, CheckCircle2, Moon, Sun, ShieldCheck, FileText, Stamp, Pencil } from 'lucide-react';

// --- DATOS DE LOS DOCUMENTOS ---
const clausulasContrato = [
  { id: 'c1', titulo: "CLÁUSULA PRIMERA. OBJETO", contenido: "EL CONTRATISTA se obliga para con EL CONTRATANTE a desarrollar el entorno interactivo en Unity, la escritura del código C# y la optimización del rendimiento para una experiencia de Realidad Virtual (VR) destinada al lanzamiento de un nuevo producto, por cuenta y riesgo de EL CONTRATANTE, siguiendo estrictamente el plan, guion, modelos 3D y las mecánicas de juego señaladas y suministradas por este." },
  { id: 'c2', titulo: "CLÁUSULA SEGUNDA. ENTREGABLES", contenido: "Al finalizar el desarrollo, EL CONTRATISTA deberá entregar el software ejecutable (.exe), así como el código fuente completo, manuales y cualquier otro archivo derivado de la ejecución de este contrato, esto hasta el día 20 de abril, día del festival." },
  { id: 'c3', titulo: "CLÁUSULA TERCERA. HONORARIOS", contenido: "EL CONTRATANTE pagará a EL CONTRATISTA la suma de VEINTITRÉS MILLONES DE PESOS M/CTE ($23.000.000) en honorarios, por la ejecución total de la obra. Dentro de este valor no se incluyen viáticos de ningún tipo." },
  { id: 'c4', titulo: "CLÁUSULA CUARTA. CESIÓN DE DERECHOS", contenido: "EL CONTRATISTA cede a favor de EL CONTRATANTE la totalidad de los derechos patrimoniales sobre el software desarrollado, incluyendo su reproducción, distribución, comunicación pública, transformación, adaptación y explotación comercial, durante un tiempo de 10 años." },
  { id: 'c5', titulo: "CLÁUSULA QUINTA. REGISTRO", contenido: "El presente contrato será registrado ante notaría pública y ante la Dirección Nacional de Derecho de Autor (DNDA) para su publicidad y oponibilidad." },
  { id: 'c6', titulo: "CLÁUSULA SEXTA. CONFIDENCIALIDAD", contenido: "EL CONTRATISTA se obliga a mantener en estricta reserva y no divulgar a terceros la información técnica, comercial, lógica interna de la marca, guiones, ni el código fuente del proyecto. Queda expresamente prohibida la publicación del código fuente en repositorios públicos, plataformas de portafolio o cualquier otro medio, durante un tiempo de 10 años." },
  { id: 'c7', titulo: "CLÁUSULA SÉPTIMA. COMPETENCIA DESLEAL", contenido: "EL CONTRATISTA no podrá adaptar, modificar, revender ni licenciar el software desarrollado (ni versiones alteradas del mismo mediante cambios estéticos, de color o de logotipos) a marcas de la competencia ni a ningún tercero, durante un tiempo de 10 años." },
  { id: 'c8', titulo: "CLÁUSULA OCTAVA. SANCIONES", contenido: "El incumplimiento de cualquiera de las obligaciones dará lugar a la terminación inmediata del contrato y al cobro de una sanción pecuniaria equivalente a VEINTE MILLONES DE PESOS M/CTE ($20.000.000), sin perjuicio de las acciones legales correspondientes." },
  { id: 'c9', titulo: "CLÁUSULA NOVENA. VIÁTICOS", contenido: "Los gastos por concepto de viáticos, registrales y cualquier otro gasto conexo no se entenderá comprendido en los honorarios. Serán asumidos en su totalidad por la EMPRESA. El CONTRATANTE estará obligado a reportar la totalidad de los gastos aportando los soportes idóneos." }
];

const clausulasLicencia = [
  { id: 'l1', titulo: "PRIMERA. OBJETO", contenido: "EL LICENCIANTE concede a EL LICENCIATARIO una licencia de uso sobre el software de experiencia de Realidad Virtual (VR) desarrollado en Unity, incluyendo el código fuente en C#, mecánicas interactivas y optimización del sistema." },
  { id: 'l2', titulo: "SEGUNDA. ALCANCE DEL OBJETO", contenido: "La presente licencia permitirá a EL LICENCIATARIO: reproducir el software, usarlo en ferias y eventos, modificarlo, adaptarlo a campañas publicitarias, distribuirlo, comunicarlo públicamente, integrarlo en otros proyectos y explotarlo comercialmente." },
  { id: 'l3', titulo: "TERCERA Y CUARTA. DURACIÓN Y TERRITORIO", contenido: "La licencia se concede por el término de protección de los derechos patrimoniales de autor conforme a la legislación colombiana y aplica tanto en el territorio nacional como internacional." },
  { id: 'l4', titulo: "QUINTA. VALOR", contenido: "Las partes acuerdan que la presente licencia se otorga a título oneroso, incluido dentro del pago de los honorarios profesionales del desarrollo del software." },
  { id: 'l5', titulo: "SEXTA Y SÉPTIMA. CONFIDENCIALIDAD", contenido: "EL LICENCIANTE se obliga a no divulgar el código fuente ni mecánicas. Se prohíbe usar en portafolios o repositorios públicos. Tampoco podrá reutilizar, vender o licenciar el software a terceros, incluso con modificaciones estéticas." },
  { id: 'l6', titulo: "OCTAVA, NOVENA Y DÉCIMA. LEGALIDAD", contenido: "EL LICENCIATARIO respetará los derechos morales. Las partes procurarán resolver las diferencias por acuerdo directo, o acudirán a la jurisdicción ordinaria colombiana. El contrato se perfecciona con la firma." }
];

// --- COMPONENTES AUXILIARES ANIMADOS ---

const TiltCard = ({ children, theme, estaAceptada }) => {
  const x = useMotionValue(0);
  const y = useMotionValue(0);
  const rotateX = useTransform(y, [-100, 100], [10, -10]);
  const rotateY = useTransform(x, [-100, 100], [-10, 10]);

  function handleMouse(event) {
    const rect = event.currentTarget.getBoundingClientRect();
    const centerX = rect.left + rect.width / 2;
    const centerY = rect.top + rect.height / 2;
    x.set(event.clientX - centerX);
    y.set(event.clientY - centerY);
  }

  function handleMouseLeave() {
    x.set(0);
    y.set(0);
  }

  return (
    <motion.div
      style={{ scale: 1, rotateX, rotateY, perspective: 1000, marginBottom: '0.75rem' }}
      onMouseMove={handleMouse}
      onMouseLeave={handleMouseLeave}
      whileHover={{ scale: 1.02, transition: { duration: 0.2 } }}
    >
      <div style={{ border: `1px solid ${estaAceptada ? theme.success : theme.border}`, borderRadius: '12px', overflow: 'hidden', backgroundColor: theme.card, transition: 'border-color 0.2s', boxShadow: '0 2px 5px rgba(0,0,0,0.02)' }}>
        {children}
      </div>
    </motion.div>
  );
};

const SignaturePad = ({ theme, onFinalizar }) => {
  const canvasRef = useRef(null);
  const [isDrawing, setIsDrawing] = useState(false);
  const [hasSignature, setHasSignature] = useState(false);

  useEffect(() => {
    const canvas = canvasRef.current;
    const ctx = canvas.getContext('2d');
    ctx.strokeStyle = theme.text;
    ctx.lineWidth = 2;
    ctx.lineCap = 'round';
  }, [theme.text]);

  const startDrawing = (e) => {
    const ctx = canvasRef.current.getContext('2d');
    const { offsetX, offsetY } = e.nativeEvent;
    ctx.beginPath();
    ctx.moveTo(offsetX, offsetY);
    setIsDrawing(true);
    setHasSignature(true);
  };

  const draw = (e) => {
    if (!isDrawing) return;
    const ctx = canvasRef.current.getContext('2d');
    const { offsetX, offsetY } = e.nativeEvent;
    ctx.lineTo(offsetX, offsetY);
    ctx.stroke();
  };

  const stopDrawing = () => {
    setIsDrawing(false);
  };

  const clearCanvas = () => {
    const canvas = canvasRef.current;
    const ctx = canvas.getContext('2d');
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    setHasSignature(false);
  };

  return (
    <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} style={{ textAlign: 'center', marginTop: '2rem', padding: '1.5rem', borderTop: `1px solid ${theme.border}` }}>
      <p style={{ fontWeight: '600', marginBottom: '1rem', color: theme.text, display: 'flex', alignItems: 'center', justifyContent: 'center', gap: '0.5rem' }}>
        <Pencil size={18} /> Dibuja tu firma en el recuadro para finalizar
      </p>
      <canvas
        ref={canvasRef}
        width={400}
        height={150}
        style={{ backgroundColor: theme.isDark ? '#27272a' : '#f4f4f5', border: `2px dashed ${theme.border}`, borderRadius: '8px', cursor: 'crosshair', touchAction: 'none', maxWidth: '100%' }}
        onMouseDown={startDrawing}
        onMouseMove={draw}
        onMouseUp={stopDrawing}
        onMouseLeave={stopDrawing}
      />
      <div style={{ marginTop: '1rem', display: 'flex', gap: '1rem', justifyContent: 'center' }}>
        <button onClick={clearCanvas} style={{ backgroundColor: 'transparent', color: theme.textMuted, border: 'none', cursor: 'pointer', fontSize: '0.9rem' }}>Borrar</button>
        <button
          onClick={onFinalizar}
          disabled={!hasSignature}
          style={{ backgroundColor: hasSignature ? theme.primary : theme.border, color: hasSignature ? 'white' : theme.textMuted, padding: '0.75rem 2rem', borderRadius: '8px', border: 'none', fontWeight: 'bold', cursor: hasSignature ? 'pointer' : 'not-allowed', transition: 'all 0.3s' }}
        >
          Finalizar Firma
        </button>
      </div>
    </motion.div>
  );
};

const Confetti = ({ theme }) => {
  const colors = [theme.primary, theme.success, '#f59e0b', '#ec4899'];
  return (
    <div style={{ position: 'absolute', inset: 0, overflow: 'hidden', pointerEvents: 'none' }}>
      {[...Array(30)].map((_, i) => (
        <motion.div
          key={i}
          style={{ position: 'absolute', width: '10px', height: '10px', backgroundColor: colors[i % colors.length], borderRadius: i % 2 === 0 ? '50%' : '2px', top: '-10px', left: `${Math.random() * 100}%` }}
          animate={{ y: ['0vh', '100vh'], x: [0, (Math.random() - 0.5) * 200], rotate: [0, Math.random() * 360] }}
          transition={{ duration: Math.random() * 2 + 2, delay: Math.random() * 0.5, repeat: Infinity, ease: 'linear' }}
        />
      ))}
    </div>
  );
};

// --- COMPONENTE PRINCIPAL ---
export default function App() {
  const [documentoActivo, setDocumentoActivo] = useState('contrato');
  const [clausulaActiva, setClausulaActiva] = useState(null);
  const [aceptadasContrato, setAceptadasContrato] = useState([]);
  const [aceptadasLicencia, setAceptadasLicencia] = useState([]);
  const [mostrandoPadContrato, setMostrandoPadContrato] = useState(false);
  const [mostrandoPadLicencia, setMostrandoPadLicencia] = useState(false);
  const [firmadoContrato, setFirmadoContrato] = useState(false);
  const [firmadoLicencia, setFirmadoLicencia] = useState(false);
  const [modoOscuro, setModoOscuro] = useState(false);

  const datosActuales = documentoActivo === 'contrato' ? clausulasContrato : clausulasLicencia;
  const aceptadasActuales = documentoActivo === 'contrato' ? aceptadasContrato : aceptadasLicencia;
  const setAceptadasActuales = documentoActivo === 'contrato' ? setAceptadasContrato : setAceptadasLicencia;
  const firmadoActual = documentoActivo === 'contrato' ? firmadoContrato : firmadoLicencia;
  const setFirmadoActual = documentoActivo === 'contrato' ? setFirmadoContrato : setFirmadoLicencia;
  const mostrandoPadActual = documentoActivo === 'contrato' ? mostrandoPadContrato : mostrandoPadLicencia;
  const setMostrandoPadActual = documentoActivo === 'contrato' ? setMostrandoPadContrato : setMostrandoPadLicencia;

  const progreso = (aceptadasActuales.length / datosActuales.length) * 100;
  const todasAceptadas = progreso === 100;

  const theme = {
    isDark: modoOscuro,
    bg: modoOscuro ? '#09090b' : '#f4f4f5',
    card: modoOscuro ? '#18181b' : '#ffffff',
    text: modoOscuro ? '#fafafa' : '#18181b',
    textMuted: modoOscuro ? '#a1a1aa' : '#52525b',
    border: modoOscuro ? '#27272a' : '#e4e4e7',
    primary: modoOscuro ? '#3b82f6' : '#2563eb',
    success: '#10b981',
    tabInactive: modoOscuro ? '#27272a' : '#e4e4e7'
  };

  const containerVariants = {
    hidden: { opacity: 0 },
    visible: { opacity: 1, transition: { staggerChildren: 0.1 } }
  };

  const itemVariants = {
    hidden: { y: 20, opacity: 0 },
    visible: { y: 0, opacity: 1 }
  };

  return (
    <div style={{ fontFamily: 'system-ui, -apple-system, sans-serif', minHeight: '100vh', padding: '2rem 1rem', backgroundColor: theme.bg, color: theme.text, transition: 'all 0.3s ease', perspective: '1000px' }}>
      <div style={{ maxWidth: '800px', margin: '0 auto' }}>
        
        {/* Header */}
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '2rem' }}>
          <div>
            {/* Título forzado con el color del tema para evitar sobreescritura de index.css */}
            <motion.h1 initial={{ x: -20, opacity: 0 }} animate={{ x: 0, opacity: 1 }} style={{ fontSize: '2.5rem', fontWeight: '800', margin: 0, letterSpacing: '-0.02em', color: theme.text }}>
              Gestión Jurídica
            </motion.h1>
            <motion.p initial={{ x: -20, opacity: 0 }} animate={{ x: 0, opacity: 1 }} transition={{ delay: 0.1 }} style={{ color: theme.textMuted, margin: '0.5rem 0 0 0', fontWeight: '500' }}>
              Empresa Publicitaria "Ralf"
            </motion.p>
          </div>
          <button onClick={() => setModoOscuro(!modoOscuro)} style={{ padding: '0.75rem', borderRadius: '50%', border: `1px solid ${theme.border}`, backgroundColor: theme.card, color: theme.text, cursor: 'pointer', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
            {modoOscuro ? <Sun size={20} /> : <Moon size={20} />}
          </button>
        </div>

        {/* Tabs */}
        <div style={{ display: 'flex', gap: '0.5rem', marginBottom: '1.5rem', backgroundColor: theme.tabInactive, padding: '0.5rem', borderRadius: '12px' }}>
          {['contrato', 'licencia'].map(tipo => (
            <button key={tipo} onClick={() => { setDocumentoActivo(tipo); setClausulaActiva(null); setMostrandoPadActual(false); }} style={{ flex: 1, padding: '0.75rem', display: 'flex', alignItems: 'center', justifyContent: 'center', gap: '0.5rem', border: 'none', borderRadius: '8px', cursor: 'pointer', fontWeight: '600', backgroundColor: documentoActivo === tipo ? theme.card : 'transparent', color: documentoActivo === tipo ? theme.text : theme.textMuted, transition: 'all 0.2s' }}>
              {tipo === 'contrato' ? <FileText size={18} /> : <Stamp size={18} />}
              {tipo === 'contrato' ? 'Prestación de Servicios' : 'Licencia de Uso'}
            </button>
          ))}
        </div>

        {/* Progreso */}
        <div style={{ marginBottom: '2rem' }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '0.5rem', fontSize: '0.875rem', color: theme.textMuted, fontWeight: '600' }}>
            <span>Validación de Cláusulas</span>
            <span>{Math.round(progreso)}%</span>
          </div>
          <div style={{ height: '6px', backgroundColor: theme.border, borderRadius: '4px', overflow: 'hidden' }}>
            <motion.div key={documentoActivo} initial={{ width: 0 }} animate={{ width: `${progreso}%` }} style={{ height: '100%', backgroundColor: todasAceptadas ? theme.success : theme.primary }} transition={{ duration: 0.4 }} />
          </div>
        </div>

        {/* Contenido */}
        <AnimatePresence mode="wait">
          {!firmadoActual ? (
            <motion.div key={`doc-${documentoActivo}`} initial="hidden" animate="visible" exit={{ opacity: 0, x: -20 }} variants={containerVariants} style={{ backgroundColor: theme.card, padding: '2rem', borderRadius: '16px', border: `1px solid ${theme.border}`, boxShadow: modoOscuro ? '0 10px 40px rgba(0,0,0,0.4)' : '0 10px 40px rgba(0,0,0,0.05)' }}>
              
              <div style={{ display: 'flex', flexDirection: 'column', marginBottom: '2.5rem' }}>
                {datosActuales.map((clausula) => {
                  const estaAceptada = aceptadasActuales.includes(clausula.id);
                  const estaActiva = clausulaActiva === clausula.id;
                  return (
                    <motion.div key={clausula.id} variants={itemVariants}>
                      <TiltCard theme={theme} estaAceptada={estaAceptada}>
                        <button onClick={() => setClausulaActiva(estaActiva ? null : clausula.id)} style={{ width: '100%', padding: '1.25rem', display: 'flex', justifyContent: 'space-between', alignItems: 'center', backgroundColor: 'transparent', border: 'none', cursor: 'pointer', color: theme.text, textAlign: 'left' }}>
                          <div style={{ display: 'flex', alignItems: 'center', gap: '1rem' }}>
                            
                            {/* Hitbox Ampliada */}
                            <div 
                              onClick={(e) => { 
                                e.preventDefault(); 
                                e.stopPropagation(); 
                                setAceptadasActuales(estaAceptada ? aceptadasActuales.filter(item => item !== clausula.id) : [...aceptadasActuales, clausula.id]); 
                                setClausulaActiva(null); 
                              }} 
                              style={{ padding: '15px', margin: '-15px', cursor: 'pointer', position: 'relative', zIndex: 10, display: 'flex', alignItems: 'center', justifyContent: 'center' }}
                            >
                              <div style={{ width: '24px', height: '24px', borderRadius: '6px', border: `2px solid ${estaAceptada ? theme.success : theme.textMuted}`, display: 'flex', alignItems: 'center', justifyContent: 'center', backgroundColor: estaAceptada ? theme.success : 'transparent', transition: 'all 0.2s' }}>
                                {estaAceptada && <CheckCircle2 size={16} color="white" />}
                              </div>
                            </div>

                            <span style={{ fontWeight: '600', fontSize: '0.95rem', textDecoration: estaAceptada ? 'line-through' : 'none', opacity: estaAceptada ? 0.6 : 1 }}>{clausula.titulo}</span>
                          </div>
                          <motion.div animate={{ rotate: estaActiva ? 180 : 0 }}><ChevronDown size={18} color={theme.textMuted} /></motion.div>
                        </button>
                        <AnimatePresence>
                          {estaActiva && (
                            <motion.div initial={{ height: 0, opacity: 0 }} animate={{ height: 'auto', opacity: 1 }} exit={{ height: 0, opacity: 0 }}>
                              <div style={{ padding: '0 1.25rem 1.25rem 3.75rem', color: theme.textMuted, lineHeight: '1.6', fontSize: '0.95rem', borderTop: `1px solid ${theme.border}` }}>{clausula.contenido}</div>
                            </motion.div>
                          )}
                        </AnimatePresence>
                      </TiltCard>
                    </motion.div>
                  );
                })}
              </div>

              {!mostrandoPadActual ? (
                <div style={{ textAlign: 'center' }}>
                  <motion.button whileHover={todasAceptadas ? { scale: 1.05 } : {}} whileTap={todasAceptadas ? { scale: 0.95 } : {}} onClick={() => setMostrandoPadActual(true)} disabled={!todasAceptadas} style={{ backgroundColor: todasAceptadas ? theme.primary : theme.border, color: todasAceptadas ? 'white' : theme.textMuted, padding: '1rem 2.5rem', borderRadius: '8px', border: 'none', fontSize: '1.1rem', fontWeight: 'bold', cursor: todasAceptadas ? 'pointer' : 'not-allowed', display: 'inline-flex', alignItems: 'center', gap: '0.75rem', transition: 'all 0.3s' }}>
                    <FileSignature size={20} /> Firmar Documento
                  </motion.button>
                </div>
              ) : (
                <SignaturePad theme={theme} onFinalizar={() => setFirmadoActual(true)} />
              )}

            </motion.div>
          ) : (
            <motion.div key={`exito-${documentoActivo}`} initial={{ scale: 0.9, opacity: 0 }} animate={{ scale: 1, opacity: 1 }} style={{ backgroundColor: theme.card, padding: '4rem 2rem', borderRadius: '16px', border: `1px solid ${theme.success}`, textAlign: 'center', position: 'relative', overflow: 'hidden', boxShadow: `0 20px 40px ${modoOscuro ? 'rgba(16,185,129,0.1)' : 'rgba(16,185,129,0.15)'}` }}>
              <Confetti theme={theme} />
              <motion.div initial={{ scale: 0 }} animate={{ scale: 1 }} transition={{ type: "spring", delay: 0.2 }} style={{ width: '70px', height: '70px', backgroundColor: theme.success, borderRadius: '50%', display: 'flex', alignItems: 'center', justifyContent: 'center', margin: '0 auto 1.5rem auto', position: 'relative', zIndex: 1 }}>
                <ShieldCheck size={36} color="white" />
              </motion.div>
              <h2 style={{ fontSize: '2rem', fontWeight: '800', margin: '0 0 1rem 0', color: theme.text, position: 'relative', zIndex: 1 }}>
                {documentoActivo === 'contrato' ? 'Contrato Firmado' : 'Licencia Otorgada'}
              </h2>
              <p style={{ fontSize: '1.1rem', color: theme.textMuted, maxWidth: '500px', margin: '0 auto 2rem auto', position: 'relative', zIndex: 1, lineHeight: '1.6' }}>
                {documentoActivo === 'contrato' ? 'La Empresa "Ralf" ha consolidado la cesión total de derechos patrimoniales y el acuerdo de confidencialidad a 10 años.' : 'Se ha estructurado la licencia de uso especificando estrictamente el alcance y las prohibiciones de reutilización del código.'}
              </p>
              <button onClick={() => { setFirmadoActual(false); setMostrandoPadActual(false); }} style={{ backgroundColor: 'transparent', color: theme.primary, border: `1px solid ${theme.primary}`, padding: '0.75rem 1.5rem', borderRadius: '8px', fontWeight: 'bold', cursor: 'pointer', position: 'relative', zIndex: 1 }}>Revisar Documento</button>
            </motion.div>
          )}
        </AnimatePresence>
        
      </div>
    </div>
  );
}