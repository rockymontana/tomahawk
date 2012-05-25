macro(add_tomahawk_translation language)
    list(APPEND TOMAHAWK_LANGUAGES ${language})
endmacro()

macro(tomahawk_write_language_qrc)
    foreach(language ${TOMAHAWK_LANGUAGES})
        message(STATUS "lang: ${language}")
    endforeach()
endmacro()