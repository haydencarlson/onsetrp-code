function ResetScoreboard() {
    let table = document.getElementsByClassName("table-server")[0];
    table.getElementsByTagName("tbody")[0].innerHTML = table.rows[0].innerHTML;

    let tableOuter = document.getElementsByClassName("table")[0];
    tableOuter.scrollTop = 0;
}

function AddPlayer(name, job, sessiontime, admin, ping) {
    $('#server-table-tbody').empty();
    $('#server-table-tbody').append(
    `<tr>
        <td>${name}</td>
        <td>${job.charAt(0).toUpperCase() + job.slice(1)}</td>
        <td>${admin === 'true' ? "Admin" : "Player"}</td>
        <td>${SecondsToTime(sessiontime)}</td>
        <td>${ping}ms</td>
    </tr>`);
}

function AddLaws(laws) {
    $('#law-table-tbody').empty();
    laws.forEach((law) => {
        $('#law-table-tbody').append(`
        <tr>
            <td style="width:70px;">${law.id}</td>
            <td style="min-width:250px; max-width: 250px;">${law.law_name}</td>
            <td style="width:150px;">${law.action}</td>
        </tr>`);
    });
}

function SecondsToTime(d) {
    d = Number(d);
    var h = Math.floor(d / 3600);
    var m = Math.floor((d % 3600) / 60);
    var s = Math.floor((d % 3600) % 60);

    var hDisplay = h > 0 ? h + (h == 1 ? " hr, " : " hrs, ") : "";
    var mDisplay = m > 0 ? m + (m == 1 ? " min, " : " mins, ") : "";
    var sDisplay = s > 0 ? s + (s == 1 ? " sec" : " secs") : "";
    return hDisplay + mDisplay + sDisplay;
}

function SetInformation(name, players, maxplayers) {
    let infoPlayers = document.getElementsByClassName("players")[0];
    infoPlayers.getElementsByTagName(
        "small"
    )[0].innerHTML = `Players: ${players}/${maxplayers}`;
}