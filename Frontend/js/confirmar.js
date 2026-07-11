
 // Datos guardados desde reservar.js
const reserva = JSON.parse(sessionStorage.getItem("ultimaReserva"));
 if (!reserva) {
     // Si el usuario entra directamente a esta pantalla
    window.location.href = "inicio.html";
 }
 // ---------- Usuario ----------
 document.getElementById("usuario-nombre").textContent =
    reserva.nombre;
 document.getElementById("usuario-avatar").textContent =
    reserva.nombre
        .split(" ")
        .map(n => n[0])
        .join("")
        .substring(0,2)
        .toUpperCase();
 // ---------- Datos reserva ----------
 document.getElementById("conf-espacio").textContent =
    reserva.espacio;
 document.getElementById("conf-fecha").textContent =
    reserva.fecha;
 document.getElementById("conf-hora").textContent =
    `${reserva.horaInicio} - ${reserva.horaFin}`;
 document.getElementById("conf-codigo").textContent =
    reserva.codigo;
 // ======================================
// Menú responsive
// ======================================
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

 // ======================================
// Cerrar sesión
// ======================================
 async function cerrarSesion(){
     try{
         const res = await fetch(
            "http://localhost:3000/api/auth/logout",
            {
                method:"POST",
                credentials:"include"
            }
        );
         const data = await res.json();
         if(data.ok){
             window.location.href="../../login.html";
         }
     }catch(error){
         console.error(error);
     }
 }