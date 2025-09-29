# Función mejorada para ajustar subtítulos con FFmpeg
# Uso: subsync -f 2.5 -s archivo.srt  (adelantar 2.5 segundos)
# Uso: subsync -b 1.8 -s archivo.srt  (atrasar 1.8 segundos)
# Uso: subsync -f 2.5 video  (busca video.srt automáticamente)
# Uso: subsync -f 2.5 -s video*.srt -r  (múltiples archivos y reemplazar)

subsync() {
    local direction=""
    local seconds=""
    local subtitle_files=()
    local replace_mode=false
    
    # Procesar argumentos
    while [[ $# -gt 0 ]]; do
        case $1 in
            -f|--forward)
                direction="forward"
                seconds="$2"
                shift 2
                ;;
            -b|--backward)
                direction="backward"
                seconds="$2"
                shift 2
                ;;
            -s|--subtitle)
                # Expandir patrones glob
                shift
                while [[ $# -gt 0 && ! "$1" =~ ^- ]]; do
                    for file in $1; do
                        if [[ -f "$file" ]]; then
                            subtitle_files+=("$file")
                        fi
                    done
                    shift
                done
                ;;
            -r|--replace)
                replace_mode=true
                shift
                ;;
            -h|--help)
                echo "Uso: subsync [OPCIÓN] ARCHIVOS..."
                echo "Ajusta la sincronización de subtítulos usando FFmpeg"
                echo ""
                echo "Opciones:"
                echo "  -f, --forward SEGUNDOS    Adelantar subtítulos N segundos"
                echo "  -b, --backward SEGUNDOS   Atrasar subtítulos N segundos"
                echo "  -s, --subtitle ARCHIVOS   Archivos de subtítulos (soporta wildcards)"
                echo "  -r, --replace             Reemplazar archivos originales"
                echo "  -h, --help                Mostrar esta ayuda"
                echo ""
                echo "Ejemplos:"
                echo "  subsync -f 2.5 -s pelicula.srt          # Un archivo"
                echo "  subsync -b 1.8 -s video*.srt            # Múltiples archivos"
                echo "  subsync -f 3 -s serie.srt -r            # Reemplazar original"
                echo "  subsync -f 2.5 video                    # Busca video.srt automáticamente"
                echo "  subsync -b 1.5 pelicula serie           # Múltiples sin -s"
                return 0
                ;;
            *)
                # Si no tiene extensión, buscar archivos .srt
                if [[ ! "$1" =~ ^- ]]; then
                    local base_name="$1"
                    if [[ ! "$base_name" =~ \. ]]; then
                        # Buscar archivos que coincidan con el patrón
                        local found_files=(${base_name}*.srt)
                        if [[ ${#found_files[@]} -gt 0 && -f "${found_files[1]}" ]]; then
                            subtitle_files+=("${found_files[@]}")
                        else
                            # Intentar con .srt directo
                            if [[ -f "${base_name}.srt" ]]; then
                                subtitle_files+=("${base_name}.srt")
                            else
                                echo "⚠️  No se encontraron archivos para: $base_name"
                            fi
                        fi
                    else
                        if [[ -f "$1" ]]; then
                            subtitle_files+=("$1")
                        else
                            echo "⚠️  Archivo no encontrado: $1"
                        fi
                    fi
                    shift
                else
                    echo "Error: Opción desconocida '$1'"
                    echo "Usa 'subsync -h' para ver la ayuda"
                    return 1
                fi
                ;;
        esac
    done
    
    # Validar argumentos
    if [[ -z "$direction" ]]; then
        echo "Error: Debes especificar -f (forward) o -b (backward)"
        return 1
    fi
    
    if [[ -z "$seconds" ]]; then
        echo "Error: Debes especificar la cantidad de segundos"
        return 1
    fi
    
    if [[ ${#subtitle_files[@]} -eq 0 ]]; then
        echo "Error: No se encontraron archivos de subtítulos para procesar"
        return 1
    fi
    
    # Validar que seconds sea un número
    if ! [[ "$seconds" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
        echo "Error: '$seconds' no es un número válido"
        return 1
    fi
    
    # Configurar offset y acción
    if [[ "$direction" == "forward" ]]; then
        offset="-${seconds}"
        action="Adelantando"
        suffix="_forw"
    else
        offset="${seconds}"
        action="Atrasando"
        suffix="_back"
    fi
    
    echo "📋 Procesando ${#subtitle_files[@]} archivo(s)..."
    echo ""
    
    local success_count=0
    local total_count=${#subtitle_files[@]}
    
    # Procesar cada archivo
    for subtitle_file in "${subtitle_files[@]}"; do
        echo "🔄 ${action} '$subtitle_file' ${seconds} segundos..."
        
        local base_name="${subtitle_file%.*}"
        local extension="${subtitle_file##*.}"
        
        if [[ "$replace_mode" == true ]]; then
            local temp_file="${base_name}_temp.${extension}"
            output_file="$temp_file"
            final_file="$subtitle_file"
        else
            output_file="${base_name}${suffix}_${seconds}s.${extension}"
            final_file="$output_file"
        fi
        
        # Ejecutar FFmpeg
        if ffmpeg -itsoffset "$offset" -i "$subtitle_file" -c copy "$output_file" -y 2>/dev/null; then
            if [[ "$replace_mode" == true ]]; then
                mv "$output_file" "$final_file"
                echo "✅ Archivo reemplazado: $final_file"
            else
                echo "✅ Archivo creado: $final_file"
            fi
            ((success_count++))
        else
            echo "❌ Error al procesar: $subtitle_file"
        fi
        echo ""
    done
    
    # Resumen final
    echo "📊 Resumen: $success_count/$total_count archivos procesados exitosamente"
}

