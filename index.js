const pty = require("node-pty");
const os = require("os");

// Чтение переменных окружения
const walletAddress = process.env.WALLET_ADDRESS;
const cpuCores = process.env.CPU_CORES;
const ram = process.env.RAM;
const diskSize = process.env.DISK_SIZE;
const diskSelection = process.env.DISK_SELECTION || "";

// Прокси параметры
const proxyIP = process.env.PROXY_IP;
const proxyPort = process.env.PROXY_PORT;
const proxyType = process.env.PROXY_TYPE || 'http';
const proxyUser = process.env.PROXY_USER;
const proxyPass = process.env.PROXY_PASS;

if (!walletAddress || !cpuCores || !ram || !diskSize) {
  console.error("Error: WALLET_ADDRESS, CPU_CORES, RAM, DISK_SIZE are required.");
  process.exit(1);
}

// Проверка наличия прокси данных
if (proxyIP && proxyPort) {
  console.log(Using proxy: ${proxyType}://${proxyUser}:${proxyPass}@${proxyIP}:${proxyPort});
}

// Инициализация pty для запуска приложения
const ptyProcess = pty.spawn("rivalz", ["run"], {
  name: "xterm-color",
  cols: 80,
  rows: 30,
  cwd: process.env.HOME,
  env: process.env,
});

// Функция для отправки данных в процессе
function sendInput(data) {
  if (data.includes("Enter wallet address (EVM):")) {
    ptyProcess.write(walletAddress + "\r");
  } else if (data.includes("Enter number of CPU cores you want to allow the client to use:")) {
    ptyProcess.write(cpuCores);
  } else if (data.includes("Enter amount of RAM (GB) you want to allow the client to use:")) {
    ptyProcess.write(ram);
  } else if (data.includes("Select drive you want to use:")) {
    if (diskSelection) {
      ptyProcess.write(diskSelection + "\r");
    }
  } else if (data.includes("Enter Disk size")) {
    ptyProcess.write(diskSize + "\r");
  }
}

// Слушаем данные от процесса
ptyProcess.on("data", function (data) {
  process.stdout.write(data);
  sendInput(data);
});

// Обрабатываем завершение процесса
ptyProcess.on("exit", function (code, signal) {
  console.log(The process ended with the code ${code} and the signal ${signal}.);
});
