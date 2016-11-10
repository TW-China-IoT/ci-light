function refreshap() {
    var request = new XMLHttpRequest();
    request.open('GET', 'http://192.168.100.1/getap', true);

    request.onload = function () {
        if (request.status >= 200 && request.status < 400) {
            var resp = JSON.parse(request.responseText);
            var select = document.getElementById("ssid");

            var ssids = Object.keys(resp);

            for (var i = 0; i < ssids.length; i++) {
                var opt = ssids[i];
                var el = document.createElement("option");
                el.textContent = opt;
                el.value = opt;
                select.appendChild(el);
            }
        } else {
            console.log("Error");
        }
    };

    request.send();
}

function refreship() {
    var request = new XMLHttpRequest();
    request.open('GET', 'http://192.168.100.1/getip', true);

    request.onload = function () {
        if (request.status >= 200 && request.status < 400) {
            var resp = JSON.parse(request.responseText);
            var ele = document.getElementById("ip")
            ele.textContent = resp.ip
        } else {
            console.log("Error");
        }
    };

    request.send();
}

refreshap();
refreship();