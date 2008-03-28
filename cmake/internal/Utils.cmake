# Handy general utility macros

###############################################################################
# INSERT_INTO_MAP (_map _key _value)
# Inserts an item into a map.
MACRO (INSERT_INTO_MAP _map _key _value)
    SET ("${_map}_${_key}" "${_value}")
ENDMACRO (INSERT_INTO_MAP)


###############################################################################
# DELETE_FROM_MAP (_map _key)
# Removes an item from a map.
MACRO (DELETE_FROM_MAP _map _key)
    SET ("${_map}_${_key}")
ENDMACRO (DELETE_FROM_MAP)


###############################################################################
# GET_FROM_MAP (value _map _key)
# Gets the value of a map entry and stores it in value.
MACRO (GET_FROM_MAP value _map _key)
    SET (${value} ${${_map}_${_key}})
ENDMACRO (GET_FROM_MAP)


###############################################################################
# INSERT_INTO_GLOBAL_MAP (_map _key _value)
# Inserts an item into a global map.
MACRO (INSERT_INTO_GLOBAL_MAP _map _key _value)
    SET ("${_map}_${_key}" "${_value}" CACHE INTERNAL "Map value" FORCE)
ENDMACRO (INSERT_INTO_GLOBAL_MAP)


###############################################################################
# DELETE_FROM_GLOBAL_MAP (_map _key)
# Removes an item from a global map.
MACRO (DELETE_FROM_GLOBAL_MAP _map _key)
    SET ("${_map}_${_key}" CACHE INTERNAL "Map value" FORCE)
ENDMACRO (DELETE_FROM_GLOBAL_MAP)


###############################################################################
# GET_FROM_GLOBAL_MAP (value _map _key)
# Gets the value of a global map entry and stores it in value.
MACRO (GET_FROM_GLOBAL_MAP value _map _key)
    SET (${value} ${${_map}_${_key}})
ENDMACRO (GET_FROM_GLOBAL_MAP)


###############################################################################
# MAP_TO_LIST (result _indexList _mapName)
# Converts a map indexed by the values in _indexList into a list.
MACRO (MAP_TO_LIST result _indexList _mapName)
    SET (${result})
    FOREACH (key ${_indexList})
        IF (${_mapName}_${key})
            LIST (APPEND ${result} ${${_mapName}_${key}})
        ENDIF (${_mapName}_${key})
    ENDFOREACH (key ${_indexList})
ENDMACRO (MAP_TO_LIST)


###############################################################################
# STRING_IN_LIST (_result _list _string)
# Check if _string is already in _list, set _result to TRUE if it is.
MACRO (STRING_IN_LIST _result _list _string)
    SET (${_result} FALSE)
    FOREACH (entry ${_list})
        IF (${entry} STREQUAL ${_string})
            SET (${_result} TRUE)
        ENDIF (${entry} STREQUAL ${_string})
    ENDFOREACH (entry ${_list})
ENDMACRO (STRING_IN_LIST)


###############################################################################
# FILTER_DUPLICATES (_result _list)
# Filters a list of strings, removing the duplicate strings.
MACRO (FILTER_DUPLICATES _result _list)
    SET (${_result})
    FOREACH (newItem ${_list})
        STRING_IN_LIST (_found "${${_result}}" ${newItem})
        IF (NOT _found)
            LIST (APPEND ${_result} ${newItem})
        ENDIF (NOT _found)
    ENDFOREACH (newItem ${_list})
ENDMACRO (FILTER_DUPLICATES)


###############################################################################
# FILTER_EMPTY (_result _list)
# Filters a list of strings, removing empty strings.
MACRO (FILTER_EMPTY _result _list)
    SET (${_result})
    FOREACH (item ${_list})
        SET (nonWhiteSpace)
        STRING (REGEX MATCHALL "[^\t\n ]" nonWhiteSpace "${item}")
        IF (nonWhiteSpace)
            LIST (APPEND ${_result} ${item})
        ENDIF (nonWhiteSpace)
    ENDFOREACH (item ${_list})
ENDMACRO (FILTER_EMPTY)


###############################################################################
# APPEND_TO_CACHED_LIST (_list _cacheDesc [items...])
# Appends items to a cached list.
MACRO (APPEND_TO_CACHED_LIST _list _cacheDesc)
    SET (tempList ${${_list}})
    FOREACH (newItem ${ARGN})
        LIST (APPEND tempList ${newItem})
    ENDFOREACH (newItem ${ARGN})
    SET (${_list} ${tempList} CACHE INTERNAL ${_cacheDesc} FORCE)
ENDMACRO (APPEND_TO_CACHED_LIST)


###############################################################################
# APPEND_TO_CACHED_STRING (_string _cacheDesc [items...])
# Appends items to a cached list.
MACRO (APPEND_TO_CACHED_STRING _string _cacheDesc)
    FOREACH (newItem ${ARGN})
        SET (${_string} "${${_string}} ${newItem}" CACHE INTERNAL ${_cacheDesc} FORCE)
    ENDFOREACH (newItem ${ARGN})
ENDMACRO (APPEND_TO_CACHED_STRING)


###############################################################################
# Macro to look for a pkg-config package
INCLUDE (UsePkgConfig)
MACRO (CHECK_PACKAGE_EXISTS _package _result _includeDir _libDir _linkFlags _cFlags)
    PKGCONFIG (${_package} ${_includeDir} ${_libDir} ${_linkFlags} ${_cFlags})
    SET (${_result} FALSE)
    IF (${_includeDir} OR ${_libDir} OR ${_linkFlags} OR ${_cFlags})
        SET (${_result} TRUE)
    ENDIF (${_includeDir} OR ${_libDir} OR ${_linkFlags} OR ${_cFlags})
ENDMACRO (CHECK_PACKAGE_EXISTS)
