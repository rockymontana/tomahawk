cmake_minimum_required(VERSION 2.6)

# Macro to copy and rename headers
macro(copy_header from to)
  configure_file(
    ${CMAKE_CURRENT_SOURCE_DIR}/${from}
    ${CMAKE_CURRENT_BINARY_DIR}/lastfm/${to}
    COPY_ONLY
  )
endmacro(copy_header)

# Copy headers
copy_header(AbstractType.h AbstractType)
copy_header(Album.h Album)
copy_header(Artist.h Artist)
copy_header(Audioscrobbler.h AudioScrobbler)
copy_header(Auth.h Auth)
copy_header(Chart.h Chart)
copy_header(FingerprintId.h FingerprintId)
copy_header(global.h global.h)
copy_header(InternetConnectionMonitor.h InternetConnectionMonitor)
copy_header(Library.h Library)
copy_header(Mbid.h Mbid)
copy_header(misc.h misc.h)
copy_header(NetworkAccessManager.h NetworkAccessManager)
copy_header(NetworkConnectionMonitor.h NetworkConnectionMonitor)
copy_header(Playlist.h Playlist)
copy_header(RadioStation.h RadioStation)
copy_header(RadioTuner.h RadioTuner)
copy_header(ScrobbleCache.h ScrobbleCache)
copy_header(ScrobblePoint.h ScrobblePoint)
copy_header(Tag.h Tag)
copy_header(Tasteometer.h Tasteometer)
copy_header(Track.h Track)
copy_header(UrlBuilder.h UrlBuilder)
copy_header(User.h User)
copy_header(ws.h ws.h)
copy_header(XmlQuery.h XmlQuery)
copy_header(Xspf.h Xspf)

include_directories(${QT_INCLUDES} ${CMAKE_CURRENT_BINARY_DIR})

set(SOURCES
    Album.cpp
    Artist.cpp
    Audioscrobbler.cpp
    Auth.cpp
    Chart.cpp
    FingerprintId.cpp
    InternetConnectionMonitor.cpp
    Library.cpp
    Mbid.cpp
    misc.cpp
    NetworkAccessManager.cpp
    NetworkConnectionMonitor.cpp
    Playlist.cpp
    RadioStation.cpp
    RadioTuner.cpp
    ScrobbleCache.cpp
    ScrobblePoint.cpp
    Tag.cpp
    Tasteometer.cpp
    Track.cpp
    UrlBuilder.cpp
    User.cpp
    ws.cpp
    XmlQuery.cpp
    Xspf.cpp
)

set(MOC_HEADERS
    Audioscrobbler.h
    InternetConnectionMonitor.h
    NetworkAccessManager.h
    NetworkConnectionMonitor.h
    RadioTuner.h
    Xspf.h
)

if(UNIX)
  if(APPLE)
    set(SOURCES ${SOURCES} mac/MNetworkConnectionMonitor_mac.cpp)
    set(MOC_HEADERS ${MOC_HEADERS} mac/MNetworkConnectionMonitor.h)
  else(APPLE)
    set(SOURCES ${SOURCES} linux/LNetworkConnectionMonitor_linux.cpp)
    set(MOC_HEADERS ${MOC_HEADERS} linux/LNetworkConnectionMonitor.h)
  endif(APPLE)
endif(UNIX)
if(WIN32)
  set(SOURCES ${SOURCES} win/WNetworkConnectionMonitor_win.cpp win/Pac.cpp win/NdisEvents.cpp )
  set(MOC_HEADERS ${MOC_HEADERS} win/WNetworkConnectionMonitor.h)
  include_directories(${CMAKE_CURRENT_SOURCE_DIR}/../../winhttp)
endif(WIN32)

qt4_wrap_cpp(MOC_SOURCES ${MOC_HEADERS})

IF( WIN32 )
    add_definitions( -DLASTFM_LIB )
    add_library(tomahawk_lastfm2 SHARED
    ${SOURCES}
    ${MOC_SOURCES}
    )
ELSE()
    add_definitions(-fPIC)
    add_library(tomahawk_lastfm2 STATIC
    ${SOURCES}
    ${MOC_SOURCES}
    )
ENDIF()

target_link_libraries(tomahawk_lastfm2
  ${QT_LIBRARIES}
  ${QT_QTDBUS_LIBRARY}

)

set_target_properties(tomahawk_lastfm2 PROPERTIES COMPILE_FLAGS "-DLASTFM_OHAI_QMAKE"  )

if(APPLE)
  target_link_libraries(tomahawk_lastfm2
    /System/Library/Frameworks/CoreFoundation.framework
    /System/Library/Frameworks/SystemConfiguration.framework
  )
endif(APPLE)


IF( WIN32 )
    install(TARGETS tomahawk_lastfm2
    RUNTIME DESTINATION bin
    LIBRARY DESTINATION lib${LIB_SUFFIX}
    ARCHIVE DESTINATION lib${LIB_SUFFIX}
    )
ENDIF()
