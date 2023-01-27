currentIndex = 0;
const resourceName = 'panama_autosalon'
var alreadyOpened = false
var lastType = null
var lastVipStatus = null

/////////////////////////////////////**PROTOTIPOVANJE DATA AUTA **/////////////////////////////////////
var normalVehicles = []

/////////////////////////////////////**KRAJ PROTOTIPOVANJE DATA AUTA **/////////////////////////////////////

function createMenu(vehicles, vip, vehicleType) {
    $("#third-window").html('')
    $("#third-window").show()
    $("#third-window").append(`
        <div class="menu-items">
            <p class="gray text-center" >Vrsta salona</p>
            <h1 class="text-center menu-item" id="normal-vehicle-list">Obican salon</h1>
            <h1 class="text-center menu-item" id="vip-vehicle-list">Vip salon</h1>
            <h1 class="text-center menu-item" id="donation-vehicle-list">Donatorska vozila</h1>
            <div class="how-to my-5">
                <h2 class="gray text-center">Kako postati VIP? </h2>
                <p class="gray text-center">
                    Vise o tome kako postati VIP na discordu u sobi "Kako postati VIP". 
                </p>
            </div>
        </div>
    `)
    $("#normal-vehicle-list").click(function() {
        currentIndex = 0;
        alreadyOpened = true
        createMainUI(currentIndex, vehicles.normal, "Obican", true, vip, vehicleType)
    })
    $("#vip-vehicle-list").click(function() {
        currentIndex = 0;
        alreadyOpened = true
        createMainUI(currentIndex, vehicles.vip, "Vip", true, vip, vehicleType)
    })
    $("#donation-vehicle-list").click(function() {
        currentIndex = 0;
        alreadyOpened = true
        createMainUI(currentIndex, vehicles.donator, "Donator", false, vip, vehicleType)
    })
}


function createList(vehicleList, type, footer, vip, vehicleType) {
    $("#header-container").html('')
    $("#content-container").html('')
    $("#footer-container").html('')
    $("#third-window").html('')
    $("#third-window").append(`
        <div class="row">
            <div class="col-12"><i class="right my-2 fas fa-times-circle" id="close-btn"></i></div>
        </div>
        <p class="text-center gray my-5">Vrsta vozila</p>
        <div class="container" id="list-container"></div>
    `);
    $.each(vehicleList, function(k,v) {
        if (typeof v.imgsrc !== 'undefined') {
            $("#list-container").append(`
                <div class="row">
                    <div class="col-12 list-card my-2">
                        <div class="row">
                            <div class="col-2 pic-slot d-flex align-items-center"><img class="mx-2" src="`+ v.imgsrc +`" style="width: 100%;"></div>
                            <div class="col-2 d-flex align-items-center"><span class="">`+ v.brand + " " + v.name +`</span></div>
                            <div class="col-6 d-flex align-items-center"><span>`+ v.price +`$</span></div>
                            <div class="col-1 eye d-flex align-items-center"><i id="btn-`+ k +`" class="fas fa-eye eye-right"></i></div>
                        </div>
                    </div>
                </div>
            `);
            $("#btn-" + k).click(function() {
                $("#third-window").html('');
                currentIndex = k
                createMainUI(currentIndex, vehicleList, type, footer, vip, vehicleType)
            });
        }
    });
    $("#close-btn").click(function() {
        $("#third-window").html('')
        createMainUI(currentIndex, vehicleList, type, footer, vip, vehicleType)
    })
}

function cleanAllAndReAppend() {
    $("#header-container").html('')
    $("#content-container").html('')
    $("#footer-container").html('')
    $("#third-window").html('')
}

window.addEventListener('message', function(event)
{ 
    var item = event.data;
    switch(item.action) {
        case('show'):
            if (item.isLoaded) {
                if (lastVipStatus == null) 
                    lastVipStatus == item.vip

                if (lastType != item.vehicleType || lastVipStatus != item.vip) {
                    alreadyOpened = false;
                    currentIndex = 0;
                    cleanAllAndReAppend();
                } 
                if (!alreadyOpened) {
                    lastType = item.vehicleType
                    normalVehicles = item.vehicles
                    createMenu(normalVehicles, item.vip, item.vehicleType);
                };
                $("#main-container").show()
            } else {
                console.log('cekajte da povuce vozila')
                close()
            }
            return;
        case('garage'):
            $("#garage-container").show()
            createGarageList(item.garage, item.garageList, item.isEmpty)
            return;
        default:
            return;
    }
});

function createGarageList(garage, vehicleList, isEmpty) {
    let counter = 0
    $("#garage-container").append(`
        <p class="text-center gray my-5">Garaza: `+ garage.toUpperCase() +`</p>
        <div class="container" id="garage-list-container"></div>
    `);
    if (!isEmpty) { 
        $.each(vehicleList, function(k,v) {
            if (garage == v.garage && v.stored) {
                counter ++;
                let body = Math.floor(v.body)
                let engine = Math.floor(v.engineHP)
                let stats = [];
                if (body == 1000) stats[0] = 'Nije osteceno (' + body + ')'
                else if (body >= 700) stats[0] = 'Malo osteceno (' + body + ')'
                else if (body >= 400) stats[0] = 'Vece ostecenje (' + body + ')'
                else stats[0] = 'Jako osteceno (' + body + ')' 
                if (engine == 1000) stats[1] = 'Nije osteceno (' + engine + ')'
                else if (engine >= 700) stats[1] = 'Malo osteceno (' + engine + ')'
                else if (engine >= 400) stats[1] = 'Vece ostecenje (' + engine + ')'
                else stats[1] = 'Jako osteceno (' + engine + ')' 
                let damageString = `
                <br> <i class="fas fa-gas-pump red" style="font-size:150%;"></i> Gorivo: `+ v.fuel +`%  ` + `<br>
                <i class="fas fa-car-crash red" style="font-size:150%;"></i> Karoserija: `+ stats[0] +` <br> 
                <i class="fas fa-car-battery red" style="font-size:150%;"></i> Motor: `+ stats[1] +`               
                `
                $("#garage-list-container").append(`
                    <div class="row">
                        <div class="col-12 list-card my-2">
                            <div class="row">
                                <div class="col-2 pic-slot d-flex align-items-center"><img class="mx-2" src="`+ v.imgsrc +`" style="width: 100%;"></div>
                                <div class="col-2 d-flex align-items-center"><span>`+ v.brand + " " + v.name + " " + '<br><i class="fas fa-warehouse garage-smx2-font gray"></i> <span class="garage-smx2-font gray">' + v.garage.toUpperCase() +'</span>' + `</span></div>
                                <div class="col-4 d-flex align-items-center">
                                        <span class="garage-sm-font">Tablice: `+ k +` ` + '<span class="garage-smx1-font gray">' + damageString + '</span>' + `</span>
                                </div>
                                <div class="col-3 eye">
                                    <button class="list-btn" id="takeout-`+ k +`">Izvadi vozilo</button>
                                </div>
                            </div>
                        </div>
                    </div>
                `); 
            }
            $("#takeout-" + k).click(function() {
                $.post('http://' + resourceName + '/takeVehicleOut', JSON.stringify({
                    plate : k, garage : garage, props : v.carProps, stored : v.stored, engineHP : v.engineHP, fuel : v.fuel, body: v.body
                }))
                close()
            })
        }); 
        if (counter == 0) {  
            if (garage != 'pauk')
            $("#garage-container").append(`
                <div class="col-12 list-card my-2">
                    <h1 class="text-center">Nemate nijedno vozilo u ovoj garazi</h1>
                </div>
            `);
            else
            $("#garage-container").append(`
            <div class="col-12 list-card my-2">
                <h1 class="text-center">Nemate nijedno vozilo na parking servisu</h1>
            </div>
        `);
        }
    } else {
        $("#garage-container").append(`
            <div class="col-12 list-card my-2">
                <h1 class="text-center">Nemate nijedno vozilo u ovoj garazi</h1>
            </div>
        `);
    }
}

function createMainUI(index, vehicles, type, footer, vip, vehicleType) {
    $("#third-window").html('')
    createHeader(type, vehicles, footer, vip, vehicleType)
    contentUI(index, vehicles, footer, vip, type, vehicleType)
} 

function createHeader(type, vehicleList, footer, vip, vehicleType) {
    $("#header-container").append(`
        <div class="col-4">
            <img src="img/Logo.png" style="width: 120px; height: auto;" class="mx-4">
        </div>
        <div class="col-8">
            <a href="#" class="float-right mx-4 my-2" id="menu-back"><i class="fas fa-arrow-left"></i></a>
            <a href="#" class="float-right mx-4 my-2 no-text-decoration white" id="listVehicles">Lista vozila <span class="gray">` + "(" + type + ")" + ` <i class="gray fas fa-chevron-circle-down"></i></span></a>
        </div>
    `);
    $("#listVehicles").click(function() {
      createList(vehicleList, type, footer, vip, vehicleType)  
    });
    $("#menu-back").click(function() {
        $("#header-container").html('')
        $("#content-container").html('')
        $("#footer-container").html('')
        createMenu(normalVehicles, vip, vehicleType)
    })
}

function contentUI(index, vehicles, footer, vip, type, vehicleType) {
    if (vehicles[index] == 'none') {
        return;
    }
    if (typeof vehicles[index - 1] === 'undefined') {
        vehicles[index - 1] = 'none'
    }
    if (typeof vehicles[index + 1] === 'undefined') {
        vehicles[index+1] = 'none'
    }
    $("#content-container").append(`
        <div class="col-2">
            <div class="btn-wrapper">    
                <a class="circle-btn" id="prev-btn" href="#">
                    <img id="left-image" src="`+ (typeof vehicles[index - 1].imgsrc === 'undefined' ? 'https://kknd26.ru/images/no_photo.png' : vehicles[index - 1].imgsrc) +`">
                </a>
            </div>
        </div>
        <div class="col-8">
            <div class="col-12">
                <h4 class="text-center">`+ vehicles[index].brand +`</h4><h1 class="text-center">`+ vehicles[index].name +`</h1>
            </div>
            <div class="col-12 pic-container">
                <img id="center-image" src="`+ vehicles[index].imgsrc +`" class="mx-auto">
            </div>
            <div class="col-12">
                <div class="row">
                    <div class="col-4"><h2 class="text-center">` + vehicles[index].content[0] + `</h2><p class="text-center gray">0-100</p></div>
                    <div class="col-4"><h2 class="text-center">` + vehicles[index].content[1] + `</h2><p class="text-center gray">MAXIMALNA BRZINA</p></div>
                    <div class="col-4"><h2 class="text-center">` + vehicles[index].content[2] + `</h2><p class="text-center gray">BROJ BRZINA</p></div>
                </div>
            </div>
        </div>
        <div class="col-2">
            <div class="btn-wrapper">
                <a class="circle-btn-right" id="next-btn" href="#">
                    <img id="right-image" src="`+ (typeof vehicles[index + 1].imgsrc === 'undefined' ? 'https://kknd26.ru/images/no_photo.png' : vehicles[index + 1].imgsrc) +`">
                </a>
            </div>
        </div>
    `);
    if (footer && vip || type == 'Obican') {
        footerUI(index, vehicles, vehicleType); 
    }
    $("#next-btn").click(function(){
        if (vehicles[index + 1] != 'none') {
            currentIndex ++;
            $("#footer-container").html('')
            $("#content-container").html('')
            contentUI(currentIndex, vehicles, footer, vip, type, vehicleType)            
            return;
        }
    })
    $("#prev-btn").click(function(){
        if (vehicles[index - 1] != 'none') {
            if (currentIndex > 0) currentIndex --;
            $("#footer-container").html('')
            $("#content-container").html('')
            contentUI(currentIndex, vehicles, footer, vip, type, vehicleType)            
            return;
        }
    })
}

function footerUI(index, vehicles, vehicleType) {
    $("#footer-container").append(`
        <div class="col-6">
            <p class="mx-4 price gray">cena <span>`+ vehicles[index].price +`$</span></p>
        </div>
        <div class="col-6">
            <button class="panama-btn btn-blue mx-4" id="buy`+ currentIndex +`">Kupi vozilo</button>
            <!--<button class="panama-btn btn-white" id="test`+ currentIndex+`">Test vozilo</button>-->
        </div>
    `);
    $("#test" + currentIndex).click(function() {
        $.post('http://' + resourceName + '/testvehicle', JSON.stringify({
            model : vehicles[currentIndex].model, vehicleType : vehicleType
        }))
        close();
    });
    $("#buy" + currentIndex).click(function() {
        $.post('http://' + resourceName + '/buyvehicle', JSON.stringify({
            model : vehicles[currentIndex].model, price : vehicles[currentIndex].price, vehicleType : vehicleType, img : vehicles[currentIndex].imgsrc, name : vehicles[currentIndex].name, brand : vehicles[currentIndex].brand
        }))
        close();
    });
}

function cleanWindow() {
    $("#header-container").html('');
    $("#content-container").html('');
    $("#footer-container").html('');
    $("#third-window").html('');
    currentIndex = 0;
}

function close() {
    $("#main-container").hide()
    $("#garage-container").hide()
    $("#garage-container").html('')
    $.post('http://' + resourceName + '/close', JSON.stringify({}))
}

$(document).ready(function () {
    $("body").on("keyup", function(dugme) {
        closeBtn = [27];
        if (closeBtn.includes(dugme.which)) {
           close();
        }
    });
});