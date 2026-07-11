
const MESES   = ['Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre'];
const DIAS    = ['L','M','M','J','V','S','D'];
const DIAS_SM = ['Domingo','Lunes','Martes','Miércoles','Jueves','Viernes','Sábado'];
const TODAY   = new Date();

let currentYear  = TODAY.getFullYear();
let currentMonth = TODAY.getMonth();
let fechaSel     = null;
let horaSel      = null;

// ── Espacio seleccionado desde inicio.html ──
const espacioLabels = {
  futbol:      'Fútbol',
  voleibol:    'Voleibol',
  baloncesto:  'Baloncesto',
  zona_jaguar: 'Zona Jaguar'
};

const espacio = sessionStorage.getItem('espacioSeleccionado') || 'futbol';
document.getElementById('titulo-espacio').textContent = espacioLabels[espacio] || espacio;

if(espacio === "zona_jaguar"){

    document
    .getElementById("grupo-juego")
    .style.display = "block";

}else{

    document
    .getElementById("grupo-juego")
    .style.display = "none";

}

// ── Topbar fecha ──
document.getElementById('topbar-fecha').textContent =
  DIAS_SM[TODAY.getDay()] + ' ' + TODAY.getDate() + ' de ' + MESES[TODAY.getMonth()] + ' ' + TODAY.getFullYear();



// ── CALENDARIO ──
function renderCal() {

  document.getElementById('cal-mes').textContent =
    MESES[currentMonth] + ' ' + currentYear;

  document.getElementById('cal-dow').innerHTML =
    DIAS.map(d => `<div class="cal-dow">${d}</div>`).join('');

  const grid = document.getElementById('cal-grid');
  grid.innerHTML = '';

  let startDow = new Date(currentYear, currentMonth, 1).getDay();
  startDow = startDow === 0 ? 6 : startDow - 1;

  const total = new Date(currentYear, currentMonth + 1, 0).getDate();

  // Espacios vacíos antes del primer día
  for (let i = 0; i < startDow; i++) {
    grid.appendChild(document.createElement('div'));
  }

  // Días del mes
  for (let d = 1; d <= total; d++) {

    const cell = document.createElement('div');

    const fecha = new Date(currentYear, currentMonth, d);

    const fechaActual =
      `${currentYear}-${String(currentMonth + 1).padStart(2,'0')}-${String(d).padStart(2,'0')}`;

    const esHoy =
      fecha.toDateString() === TODAY.toDateString();

    const esPasado =
      fecha < new Date(TODAY.getFullYear(), TODAY.getMonth(), TODAY.getDate());

    // Comparación correcta
    const esSel = fechaSel === fechaActual;

    cell.className = 'cal-dia';

    if (esPasado) {
      cell.classList.add('pasado');
    } else if (esSel) {
      cell.classList.add('selected');
    } else if (esHoy) {
      cell.classList.add('hoy');
    }

    cell.textContent = d;

    if (!esPasado) {
      cell.onclick = () => seleccionarFecha(currentYear, currentMonth, d);
    }

    grid.appendChild(cell);
  }

}

function cambiarMes(dir) {
  currentMonth += dir;
  if(currentMonth < 0)  { currentMonth = 11; currentYear--; }
  if(currentMonth > 11) { currentMonth = 0;  currentYear++; }
  renderCal();
}

function seleccionarFecha(y, m, d) {
  fechaSel = `${y}-${String(m+1).padStart(2,'0')}-${String(d).padStart(2,'0')}`;
  horaSel  = null;
  renderCal();
  cargarHoras();
}

// ── HORAS ──
// TODO: reemplazar con fetch('/horarios?espacio=X&fecha=Y') cuando el backend esté listo
function cargarHoras() {
  const wrap  = document.getElementById('horas-wrap');
  const horas = ['07:00–08:00','08:00–09:00','09:00–10:00','10:00–11:00',
                 '14:00–15:00','15:00–16:00','16:00–18:00','18:00–20:00'];
  wrap.innerHTML = horas.map(h =>
    `<button class="hora-chip" onclick="seleccionarHora(this,'${h}')">${h}</button>`
  ).join('');
}

function seleccionarHora(el, hora) {
  document.querySelectorAll('.hora-chip').forEach(c => c.classList.remove('selected'));
  el.classList.add('selected');
  horaSel = hora;
}

// ── ENVIAR RESERVA ──

const espacios = {
  futbol: 1,
  voleibol: 2,
  baloncesto: 3,
  zona_jaguar: 4
};


async function enviarReserva() {

    const telefono = document.getElementById('campo-telefono').value.trim();
    const solicitud = document.getElementById('campo-solicitud').value.trim();
    const cantAcompanantes = parseInt(document.getElementById('campo-acompanantes').value) || 0;

    if (!fechaSel) {
        mostrarToast("Por favor selecciona una fecha.", "danger");
        return;
    }

    if (!horaSel) {
        mostrarToast("Por favor selecciona un horario.", "danger");
        return;
    }

    if (!telefono) {
        mostrarToast("Por favor ingresa un teléfono.", "danger");
        return;
    }

    const [horaInicio, horaFin] = horaSel.split("–");

    const body = {

        id_espacio: espacios[espacio], // ← importante

        fecha: fechaSel,

        hora_inicio: horaInicio,

        hora_fin: horaFin,

        telefono: telefono,

        solicitud_especial: solicitud,

        cant_acompanantes: cantAcompanantes

    };

    try {

        const res = await fetch("http://localhost:3000/api/reservas", {

            method: "POST",

            credentials: "include",

            headers: {
                "Content-Type": "application/json"
            },

            body: JSON.stringify(body)

        });

        const data = await res.json();

        
      if (data.ok) {

    // Guardamos la información para confirmar.html
    const reserva = {

        id_reserva: data.id_reserva || null,

        nombre: document.getElementById("campo-nombre").value,

        cuenta: document.getElementById("campo-cuenta").value,

        espacio: espacioLabels[espacio],

       juego:  document.getElementById("juego")?.value || null,

        fecha: fechaSel,

        horaInicio: horaInicio,

        horaFin: horaFin,

        codigo: data.codigo || ("JR-" + (data.id_reserva ?? "0000"))

    };

    sessionStorage.setItem(
        "ultimaReserva",
        JSON.stringify(reserva)
    );

    window.location.href = "confirmar.html";

} else {

    mostrarToast(
        data.mensaje || "No se pudo crear la reserva",
        "danger"
    );

}

    } catch (error) {

        console.error(error);

        mostrarToast("No se pudo conectar con el servidor.", "danger");

    }

}

function mostrarToast(mensaje, tipo="danger") {


    const toast = document.getElementById("toastMensaje");


    if(!toast){

        console.log(mensaje);
        return;

    }


    const cuerpo = toast.querySelector(".toast-body");


    cuerpo.textContent = mensaje;


    toast.className = 
    `toast text-bg-${tipo}`;


    const bsToast = new bootstrap.Toast(toast);


    bsToast.show();

}
function abrirMenu(){


    document
    .querySelector(".sidebar")
    .classList.add("activo");


    document
    .querySelector(".overlay")
    .classList.add("activo");


}



function cerrarMenu(){


    document
    .querySelector(".sidebar")
    .classList.remove("activo");


    document
    .querySelector(".overlay")
    .classList.remove("activo");


}


async function cerrarSesion() {

      console.log("Entró a cerrarSesion");

    try {

        const res = await fetch("http://localhost:3000/api/auth/logout", {

            method: "POST",
            credentials: "include"

        });

        const data = await res.json();

        if (data.ok) {

            // Redirige al login
            window.location.href = "../../login.html";

        } else {

            mostrarToast("No se pudo cerrar la sesión.", "danger");

        }

    } catch (error) {

        console.error(error);

        mostrarToast("Error al cerrar la sesión.", "danger");

    }

}


// Iniciar calendario
renderCal();

// Inicializar Choices.js en el select de juego
const selectJuego = document.getElementById('juego');
if (selectJuego) {
  new Choices(selectJuego, {
    searchEnabled: false,
    itemSelectText: '',
    shouldSort: false,
    placeholder: true,
  });
}

