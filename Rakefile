task :build do
    exec "docker build -t mado ."
end
task :run do
    exec "docker run -p 9981:9981 -v ./conf:/app/conf -v ./data:/app/data -t mado"
end