# Shell Script for backup folder to *.tar.zip

***how to use***

**singel folder**

```
./backupFolder.sh -s folder-tujuan folder-yang-akan-dikompres
```

**multi folder**

```
./backupFolder.sh -m file-config
```

untuk contoh file config seperti ```backupList```

**pedoman penulisan file config**

```
folder-yang-akan-dikompres>folder-tujuan
```

menggunakan pemisah ```>```, dan pastikan terdapat baris kosong di akhir baris

**menambahkan action**

singel folder

```
./backupFolder.sh -s folder-tujuan folder-yang-akan-dikompres -a file-action
```

multi folder

```
./backupFolder.sh -m file-config -a file-action
```

action disini akan di eksekusi sesuai sintax yang digunakan

```start```, berarti aksi akan dijalankan sebelum backup folder dilakukan
```end```, berarti aksi akan dijalankan sesudah backup folder selesai

**standart penulisan**

```
sintax command

example
start pm2 stop all
end pm2 start all
```
