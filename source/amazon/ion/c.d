module amazon.ion.c;
import core.stdc.config;
import core.stdc.stdarg: va_list;
static import core.simd;
static import std.conv;

struct Int128 { long lower; long upper; }
struct UInt128 { ulong lower; ulong upper; }

struct __locale_data { int dummy; }



alias _Bool = bool;
struct dpp {
    static struct Opaque(int N) {
        void[N] bytes;
    }

    static bool isEmpty(T)() {
        return T.tupleof.length == 0;
    }
    static struct Move(T) {
        T* ptr;
    }


    static auto move(T)(ref T value) {
        return Move!T(&value);
    }
    mixin template EnumD(string name, T, string prefix) if(is(T == enum)) {
        private static string _memberMixinStr(string member) {
            import std.conv: text;
            import std.array: replace;
            return text(` `, member.replace(prefix, ""), ` = `, T.stringof, `.`, member, `,`);
        }
        private static string _enumMixinStr() {
            import std.array: join;
            string[] ret;
            ret ~= "enum " ~ name ~ "{";
            static foreach(member; __traits(allMembers, T)) {
                ret ~= _memberMixinStr(member);
            }
            ret ~= "}";
            return ret.join("\n");
        }
        mixin(_enumMixinStr());
    }
}

extern(C)
{
    ion_error_code ion_writer_close(_ion_writer*) @nogc nothrow;
    ion_error_code ion_writer_finish(_ion_writer*, int*) @nogc nothrow;
    ion_error_code ion_writer_flush(_ion_writer*, int*) @nogc nothrow;
    ion_error_code ion_writer_write_all_values(_ion_writer*, _ion_reader*) @nogc nothrow;
    ion_error_code ion_writer_write_one_value(_ion_writer*, _ion_reader*) @nogc nothrow;
    ion_error_code ion_writer_finish_container(_ion_writer*) @nogc nothrow;
    ion_error_code ion_writer_start_container(_ion_writer*, ion_type*) @nogc nothrow;
    ion_error_code ion_writer_finish_lob(_ion_writer*) @nogc nothrow;
    ion_error_code ion_writer_append_lob(_ion_writer*, ubyte*, int) @nogc nothrow;
    ion_error_code ion_writer_start_lob(_ion_writer*, ion_type*) @nogc nothrow;
    ion_error_code ion_writer_write_blob(_ion_writer*, ubyte*, int) @nogc nothrow;
    ion_error_code ion_writer_write_clob(_ion_writer*, ubyte*, int) @nogc nothrow;
    ion_error_code ion_writer_write_string(_ion_writer*, _ion_string*) @nogc nothrow;
    ion_error_code ion_writer_write_ion_symbol(_ion_writer*, _ion_symbol*) @nogc nothrow;
    ion_error_code ion_writer_write_symbol(_ion_writer*, _ion_string*) @nogc nothrow;
    ion_error_code ion_writer_write_timestamp(_ion_writer*, _ion_timestamp*) @nogc nothrow;
    ion_error_code ion_writer_write_ion_decimal(_ion_writer*, _ion_decimal*) @nogc nothrow;
    ion_error_code ion_writer_write_decimal(_ion_writer*, decQuad*) @nogc nothrow;
    ion_error_code ion_writer_write_double(_ion_writer*, double) @nogc nothrow;
    ion_error_code ion_writer_write_ion_int(_ion_writer*, _ion_int*) @nogc nothrow;
    ion_error_code ion_writer_write_long(_ion_writer*, c_long) @nogc nothrow;
    ion_error_code ion_writer_write_int64(_ion_writer*, c_long) @nogc nothrow;
    ion_error_code ion_writer_write_int32(_ion_writer*, int) @nogc nothrow;
    ion_error_code ion_writer_write_int(_ion_writer*, int) @nogc nothrow;
    ion_error_code ion_writer_write_bool(_ion_writer*, int) @nogc nothrow;
    ion_error_code ion_writer_write_typed_null(_ion_writer*, ion_type*) @nogc nothrow;
    ion_error_code ion_writer_write_null(_ion_writer*) @nogc nothrow;
    ion_error_code ion_writer_clear_annotations(_ion_writer*) @nogc nothrow;
    ion_error_code ion_writer_write_annotation_symbols(_ion_writer*, _ion_symbol*, int) @nogc nothrow;
    ion_error_code ion_writer_write_annotations(_ion_writer*, _ion_string*, int) @nogc nothrow;
    ion_error_code ion_writer_add_annotation_symbol(_ion_writer*, _ion_symbol*) @nogc nothrow;
    ion_error_code ion_writer_add_annotation(_ion_writer*, _ion_string*) @nogc nothrow;
    ion_error_code ion_writer_clear_field_name(_ion_writer*) @nogc nothrow;
    ion_error_code ion_writer_write_field_name_symbol(_ion_writer*, _ion_symbol*) @nogc nothrow;
    ion_error_code ion_writer_write_field_name(_ion_writer*, _ion_string*) @nogc nothrow;
    ion_error_code ion_writer_add_imported_tables(_ion_writer*, _ion_collection*) @nogc nothrow;
    ion_error_code ion_writer_get_symbol_table(_ion_writer*, _ion_symbol_table**) @nogc nothrow;
    ion_error_code ion_writer_set_symbol_table(_ion_writer*, _ion_symbol_table*) @nogc nothrow;
    ion_error_code ion_writer_get_catalog(_ion_writer*, _ion_catalog**) @nogc nothrow;
    ion_error_code ion_writer_set_catalog(_ion_writer*, _ion_catalog*) @nogc nothrow;
    ion_error_code ion_writer_get_depth(_ion_writer*, int*) @nogc nothrow;
    ion_error_code ion_writer_open(_ion_writer**, _ion_stream*, _ion_writer_options*) @nogc nothrow;
    ion_error_code ion_writer_open_stream(_ion_writer**, ion_error_code function(_ion_user_stream*), void*, _ion_writer_options*) @nogc nothrow;
    ion_error_code ion_writer_open_buffer(_ion_writer**, ubyte*, int, _ion_writer_options*) @nogc nothrow;
    ion_error_code ion_writer_options_close_shared_imports(_ion_writer_options*) @nogc nothrow;
    ion_error_code ion_writer_options_add_shared_imports_symbol_tables(_ion_writer_options*, _ion_symbol_table**, int) @nogc nothrow;
    ion_error_code ion_writer_options_add_shared_imports(_ion_writer_options*, _ion_collection*) @nogc nothrow;
    ion_error_code ion_writer_options_initialize_shared_imports(_ion_writer_options*) @nogc nothrow;
    struct _ion_writer_options
    {
        int output_as_binary;
        int escape_all_non_ascii;
        int pretty_print;
        int indent_with_tabs;
        int indent_size;
        int small_containers_in_line;
        int supress_system_values;
        int flush_every_value;
        int max_container_depth;
        int max_annotation_count;
        int temp_buffer_size;
        int allocation_page_size;
        _ion_catalog* pcatalog;
        _ion_collection encoding_psymbol_table;
        decContext* decimal_context;
    }
    alias ION_WRITER_OPTIONS = _ion_writer_options;
    alias hCATALOG = _ion_catalog*;
    alias hSYMTAB = _ion_symbol_table*;
    alias hWRITER = _ion_writer*;
    alias hREADER = _ion_reader*;
    alias hOWNER = void*;
    alias iTIMESTAMP = _ion_timestamp*;
    alias iSTREAM = _ion_stream*;
    alias iCATALOG = _ion_catalog*;
    alias iSYMTAB = _ion_symbol_table*;
    alias iIMPORT = _ion_symbol_table_import*;
    alias iSYMBOL = _ion_symbol*;
    alias iSTRING = _ion_string*;
    alias ION_STREAM_HANDLER = ion_error_code function(_ion_user_stream*);
    struct _ion_user_stream
    {
        ubyte* curr;
        ubyte* limit;
        void* handler_state;
        ion_error_code function(_ion_user_stream*) handler;
    }
    struct _ion_stream;
    alias ION_STREAM = _ion_stream;
    struct _ion_collection
    {
        void* _owner;
        int _node_size;
        int _count;
        _ion_collection_node* _head;
        _ion_collection_node* _tail;
        _ion_collection_node* _freelist;
    }
    alias ION_COLLECTION = _ion_collection;
    struct _ion_timestamp
    {
        ubyte precision;
        short tz_offset;
        ushort year;
        ushort month;
        ushort day;
        ushort hours;
        ushort minutes;
        ushort seconds;
        decQuad fraction;
    }
    alias ION_TIMESTAMP = _ion_timestamp;
    struct _ion_decimal
    {
        ION_DECIMAL_TYPE type;
        static union _Anonymous_0
        {
            decQuad quad_value;
            decNumber* num_value;
        }
        _Anonymous_0 value;
    }
    alias ION_DECIMAL = _ion_decimal;
    struct _ion_int
    {
        void* _owner;
        int _signum;
        int _len;
        uint* _digits;
    }
    alias ION_INT = _ion_int;
    struct _ion_writer;
    alias ION_WRITER = _ion_writer;
    struct _ion_reader;
    alias ION_READER = _ion_reader;
    struct _ion_symbol_table_import;
    alias ION_SYMBOL_TABLE_IMPORT = _ion_symbol_table_import;
    struct _ion_symbol_table_import_descriptor;
    alias ION_SYMBOL_TABLE_IMPORT_DESCRIPTOR = _ion_symbol_table_import_descriptor;
    struct _ion_symbol
    {
        int sid;
        _ion_string value;
        _ion_symbol_import_location import_location;
        int add_count;
    }
    alias ION_SYMBOL = _ion_symbol;
    struct _ion_string
    {
        int length;
        ubyte* value;
    }
    alias ION_STRING = _ion_string;
    struct _ion_catalog;
    alias ION_CATALOG = _ion_catalog;
    struct _ion_symbol_table;
    alias ION_SYMBOL_TABLE = _ion_symbol_table;
    alias BOOL = int;
    alias BYTE = ubyte;
    alias SIZE = int;
    alias SID = int;
    struct ion_type;
    alias ION_TYPE = ion_type*;
    ion_error_code ion_timestamp_set_local_offset(_ion_timestamp*, int) @nogc nothrow;
    ion_error_code ion_timestamp_unset_local_offset(_ion_timestamp*) @nogc nothrow;
    ion_error_code ion_timestamp_get_local_offset(_ion_timestamp*, int*) @nogc nothrow;
    ion_error_code ion_timestamp_has_local_offset(_ion_timestamp*, int*) @nogc nothrow;
    ion_error_code ion_timestamp_get_thru_fraction(_ion_timestamp*, int*, int*, int*, int*, int*, int*, decQuad*) @nogc nothrow;
    ion_error_code ion_timestamp_get_thru_second(_ion_timestamp*, int*, int*, int*, int*, int*, int*) @nogc nothrow;
    ion_error_code ion_timestamp_get_thru_minute(_ion_timestamp*, int*, int*, int*, int*, int*) @nogc nothrow;
    ion_error_code ion_timestamp_get_thru_day(_ion_timestamp*, int*, int*, int*) @nogc nothrow;
    ion_error_code ion_timestamp_get_thru_month(_ion_timestamp*, int*, int*) @nogc nothrow;
    ion_error_code ion_timestamp_get_thru_year(_ion_timestamp*, int*) @nogc nothrow;
    ion_error_code ion_timestamp_for_fraction(_ion_timestamp*, int, int, int, int, int, int, decQuad*, decContext*) @nogc nothrow;
    ion_error_code ion_timestamp_for_second(_ion_timestamp*, int, int, int, int, int, int) @nogc nothrow;
    ion_error_code ion_timestamp_for_minute(_ion_timestamp*, int, int, int, int, int) @nogc nothrow;
    ion_error_code ion_timestamp_for_day(_ion_timestamp*, int, int, int) @nogc nothrow;
    ion_error_code ion_timestamp_for_month(_ion_timestamp*, int, int) @nogc nothrow;
    ion_error_code ion_timestamp_for_year(_ion_timestamp*, int) @nogc nothrow;
    ion_error_code ion_timestamp_instant_equals(const(_ion_timestamp)*, const(_ion_timestamp)*, int*, decContext*) @nogc nothrow;
    ion_error_code ion_timestamp_equals(const(_ion_timestamp)*, const(_ion_timestamp)*, int*, decContext*) @nogc nothrow;
    ion_error_code ion_timestamp_to_time_t(const(_ion_timestamp)*, c_long*) @nogc nothrow;
    ion_error_code ion_timestamp_for_time_t(_ion_timestamp*, const(c_long)*) @nogc nothrow;
    ion_error_code ion_timestamp_parse(_ion_timestamp*, char*, int, int*, decContext*) @nogc nothrow;
    ion_error_code ion_timestamp_to_string(_ion_timestamp*, char*, int, int*, decContext*) @nogc nothrow;
    ion_error_code ion_timestamp_get_precision(const(_ion_timestamp)*, int*) @nogc nothrow;
    const(char)* ion_symbol_table_type_to_str(_ION_SYMBOL_TABLE_TYPE) @nogc nothrow;
    ion_error_code ion_symbol_is_equal(_ion_symbol*, _ion_symbol*, int*) @nogc nothrow;
    ion_error_code ion_symbol_copy_to_owner(void*, _ion_symbol*, _ion_symbol*) @nogc nothrow;
    ion_error_code ion_symbol_table_close(_ion_symbol_table*) @nogc nothrow;
    ion_error_code ion_symbol_table_add_symbol(_ion_symbol_table*, _ion_string*, int*) @nogc nothrow;
    ion_error_code ion_symbol_table_get_local_symbol(_ion_symbol_table*, int, _ion_symbol**) @nogc nothrow;
    ion_error_code ion_symbol_table_get_symbol(_ion_symbol_table*, int, _ion_symbol**) @nogc nothrow;
    ion_error_code ion_symbol_table_is_symbol_known(_ion_symbol_table*, int, int*) @nogc nothrow;
    ion_error_code ion_symbol_table_find_by_sid(_ion_symbol_table*, int, _ion_string**) @nogc nothrow;
    ion_error_code ion_symbol_table_find_by_name(_ion_symbol_table*, _ion_string*, int*) @nogc nothrow;
    ion_error_code ion_symbol_table_import_symbol_table(_ion_symbol_table*, _ion_symbol_table*) @nogc nothrow;
    ion_error_code ion_symbol_table_add_import(_ion_symbol_table*, _ion_symbol_table_import_descriptor*, _ion_catalog*) @nogc nothrow;
    ion_error_code ion_symbol_table_get_imports(_ion_symbol_table*, _ion_collection**) @nogc nothrow;
    ion_error_code ion_symbol_table_set_max_sid(_ion_symbol_table*, int) @nogc nothrow;
    ion_error_code ion_symbol_table_set_version(_ion_symbol_table*, int) @nogc nothrow;
    ion_error_code ion_symbol_table_set_name(_ion_symbol_table*, _ion_string*) @nogc nothrow;
    ion_error_code ion_symbol_table_get_max_sid(_ion_symbol_table*, int*) @nogc nothrow;
    ion_error_code ion_symbol_table_get_version(_ion_symbol_table*, int*) @nogc nothrow;
    ion_error_code ion_symbol_table_get_name(_ion_symbol_table*, _ion_string*) @nogc nothrow;
    ion_error_code ion_symbol_table_get_type(_ion_symbol_table*, _ION_SYMBOL_TABLE_TYPE*) @nogc nothrow;
    ion_error_code ion_symbol_table_is_locked(_ion_symbol_table*, int*) @nogc nothrow;
    ion_error_code ion_symbol_table_lock(_ion_symbol_table*) @nogc nothrow;
    ion_error_code ion_symbol_table_unload(_ion_symbol_table*, _ion_writer*) @nogc nothrow;
    ion_error_code ion_symbol_table_load(_ion_reader*, void*, _ion_symbol_table**) @nogc nothrow;
    ion_error_code ion_symbol_table_get_system_table(_ion_symbol_table**, int) @nogc nothrow;
    ion_error_code ion_symbol_table_clone_with_owner(_ion_symbol_table*, _ion_symbol_table**, void*) @nogc nothrow;
    ion_error_code ion_symbol_table_clone(_ion_symbol_table*, _ion_symbol_table**) @nogc nothrow;
    ion_error_code ion_symbol_table_open_with_type(_ion_symbol_table**, void*, _ION_SYMBOL_TABLE_TYPE) @nogc nothrow;
    ion_error_code ion_symbol_table_open(_ion_symbol_table**, void*) @nogc nothrow;
    extern __gshared char*[0] SYSTEM_SYMBOLS;
    extern __gshared _ion_string ION_SYMBOL_SHARED_SYMBOL_TABLE_STRING;
    extern __gshared _ion_string ION_SYMBOL_MAX_ID_STRING;
    extern __gshared _ion_string ION_SYMBOL_SYMBOLS_STRING;
    extern __gshared _ion_string ION_SYMBOL_IMPORTS_STRING;
    extern __gshared _ion_string ION_SYMBOL_VERSION_STRING;
    extern __gshared _ion_string ION_SYMBOL_NAME_STRING;
    extern __gshared _ion_string ION_SYMBOL_SYMBOL_TABLE_STRING;
    extern __gshared _ion_string ION_SYMBOL_VTM_STRING;
    extern __gshared _ion_string ION_SYMBOL_ION_STRING;
    extern __gshared ubyte[0] ION_SYMBOL_SHARED_SYMBOL_TABLE_BYTES;
    extern __gshared ubyte[0] ION_SYMBOL_MAX_ID_BYTES;
    extern __gshared ubyte[0] ION_SYMBOL_SYMBOLS_BYTES;
    extern __gshared ubyte[0] ION_SYMBOL_IMPORTS_BYTES;
    extern __gshared ubyte[0] ION_SYMBOL_VERSION_BYTES;
    extern __gshared ubyte[0] ION_SYMBOL_NAME_BYTES;
    extern __gshared ubyte[0] ION_SYMBOL_SYMBOL_TABLE_BYTES;
    extern __gshared ubyte[0] ION_SYMBOL_VTM_BYTES;
    extern __gshared ubyte[0] ION_SYMBOL_ION_BYTES;
    enum _ION_SYMBOL_TABLE_TYPE
    {
        ist_EMPTY = 0,
        ist_LOCAL = 1,
        ist_SHARED = 2,
        ist_SYSTEM = 3,
    }
    enum ist_EMPTY = _ION_SYMBOL_TABLE_TYPE.ist_EMPTY;
    enum ist_LOCAL = _ION_SYMBOL_TABLE_TYPE.ist_LOCAL;
    enum ist_SHARED = _ION_SYMBOL_TABLE_TYPE.ist_SHARED;
    enum ist_SYSTEM = _ION_SYMBOL_TABLE_TYPE.ist_SYSTEM;
    alias ION_SYMBOL_TABLE_TYPE = _ION_SYMBOL_TABLE_TYPE;
    struct _ion_symbol_import_location
    {
        _ion_string name;
        int location;
    }
    alias ION_SYMBOL_IMPORT_LOCATION = _ion_symbol_import_location;
    int ion_string_is_equal(_ion_string*, _ion_string*) @nogc nothrow;
    int ion_string_is_null(_ion_string*) @nogc nothrow;
    ubyte* ion_string_get_bytes(_ion_string*) @nogc nothrow;
    ubyte ion_string_get_byte(_ion_string*, int) @nogc nothrow;
    int ion_string_get_length(_ion_string*) @nogc nothrow;
    ion_error_code ion_string_copy_to_owner(void*, _ion_string*, _ion_string*) @nogc nothrow;
    char* ion_string_strdup(_ion_string*) @nogc nothrow;
    _ion_string* ion_string_assign_cstr(_ion_string*, char*, int) @nogc nothrow;
    void ion_string_assign(_ion_string*, _ion_string*) @nogc nothrow;
    void ion_string_init(_ion_string*) @nogc nothrow;
    ion_error_code ion_stream_mark_clear(_ion_stream*) @nogc nothrow;
    ion_error_code ion_stream_mark_rewind(_ion_stream*) @nogc nothrow;
    ion_error_code ion_stream_mark_remark(_ion_stream*, c_long) @nogc nothrow;
    ion_error_code ion_stream_mark(_ion_stream*) @nogc nothrow;
    ion_error_code ion_stream_skip(_ion_stream*, int, int*) @nogc nothrow;
    ion_error_code ion_stream_truncate(_ion_stream*) @nogc nothrow;
    ion_error_code ion_stream_seek(_ion_stream*, c_long) @nogc nothrow;
    ion_error_code ion_stream_write_stream(_ion_stream*, _ion_stream*, int, int*) @nogc nothrow;
    ion_error_code ion_stream_write_byte_no_checks(_ion_stream*, int) @nogc nothrow;
    ion_error_code ion_stream_write_byte(_ion_stream*, int) @nogc nothrow;
    ion_error_code ion_stream_write(_ion_stream*, ubyte*, int, int*) @nogc nothrow;
    ion_error_code ion_stream_unread_byte(_ion_stream*, int) @nogc nothrow;
    ion_error_code ion_stream_read(_ion_stream*, ubyte*, int, int*) @nogc nothrow;
    ion_error_code ion_stream_read_byte(_ion_stream*, int*) @nogc nothrow;
    c_long ion_stream_get_marked_length(_ion_stream*) @nogc nothrow;
    c_long ion_stream_get_mark_start(_ion_stream*) @nogc nothrow;
    _IO_FILE* ion_stream_get_file_stream(_ion_stream*) @nogc nothrow;
    c_long ion_stream_get_position(_ion_stream*) @nogc nothrow;
    int ion_stream_is_mark_open(_ion_stream*) @nogc nothrow;
    int ion_stream_is_dirty(_ion_stream*) @nogc nothrow;
    int ion_stream_can_mark(_ion_stream*) @nogc nothrow;
    int ion_stream_can_seek(_ion_stream*) @nogc nothrow;
    int ion_stream_can_write(_ion_stream*) @nogc nothrow;
    int ion_stream_can_read(_ion_stream*) @nogc nothrow;
    ion_error_code ion_stream_close(_ion_stream*) @nogc nothrow;
    ion_error_code ion_stream_flush(_ion_stream*) @nogc nothrow;
    ion_error_code ion_stream_open_fd_rw(int, int, _ion_stream**) @nogc nothrow;
    ion_error_code ion_stream_open_fd_out(int, _ion_stream**) @nogc nothrow;
    ion_error_code ion_stream_open_fd_in(int, _ion_stream**) @nogc nothrow;
    ion_error_code ion_stream_open_handler_out(ion_error_code function(_ion_user_stream*), void*, _ion_stream**) @nogc nothrow;
    alias pthread_t = c_ulong;
    union pthread_mutexattr_t
    {
        char[4] __size;
        int __align;
    }
    union pthread_condattr_t
    {
        char[4] __size;
        int __align;
    }
    alias pthread_key_t = uint;
    alias pthread_once_t = int;
    union pthread_mutex_t
    {
        __pthread_mutex_s __data;
        char[40] __size;
        c_long __align;
    }
    union pthread_cond_t
    {
        __pthread_cond_s __data;
        char[48] __size;
        long __align;
    }
    union pthread_rwlock_t
    {
        __pthread_rwlock_arch_t __data;
        char[56] __size;
        c_long __align;
    }
    union pthread_rwlockattr_t
    {
        char[8] __size;
        c_long __align;
    }
    alias pthread_spinlock_t = int;
    union pthread_barrier_t
    {
        char[32] __size;
        c_long __align;
    }
    union pthread_barrierattr_t
    {
        char[4] __size;
        int __align;
    }
    ion_error_code ion_stream_open_handler_in(ion_error_code function(_ion_user_stream*), void*, _ion_stream**) @nogc nothrow;
    struct sigaction
    {
        static union _Anonymous_1
        {
            void function(int) sa_handler;
            void function(int, siginfo_t*, void*) sa_sigaction;
        }
        _Anonymous_1 __sigaction_handler;
        __sigset_t sa_mask;
        int sa_flags;
        void function() sa_restorer;
    }
    ion_error_code ion_stream_open_file_rw(_IO_FILE*, int, _ion_stream**) @nogc nothrow;
    ion_error_code ion_stream_open_file_out(_IO_FILE*, _ion_stream**) @nogc nothrow;
    ion_error_code ion_stream_open_file_in(_IO_FILE*, _ion_stream**) @nogc nothrow;
    ion_error_code ion_stream_open_stderr(_ion_stream**) @nogc nothrow;
    ion_error_code ion_stream_open_stdout(_ion_stream**) @nogc nothrow;
    ion_error_code ion_stream_open_stdin(_ion_stream**) @nogc nothrow;
    ion_error_code ion_stream_open_memory_only(_ion_stream**) @nogc nothrow;
    ion_error_code ion_stream_open_buffer(ubyte*, int, int, int, _ion_stream**) @nogc nothrow;
    alias POSITION = c_long;
    alias PAGE_ID = int;
    struct _ion_page;
    alias ION_PAGE = _ion_page;
    struct _fpx_sw_bytes
    {
        uint magic1;
        uint extended_size;
        c_ulong xstate_bv;
        uint xstate_size;
        uint[7] __glibc_reserved1;
    }
    struct _fpreg
    {
        ushort[4] significand;
        ushort exponent;
    }
    struct _fpxreg
    {
        ushort[4] significand;
        ushort exponent;
        ushort[3] __glibc_reserved1;
    }
    struct _xmmreg
    {
        uint[4] element;
    }
    struct _fpstate
    {
        ushort cwd;
        ushort swd;
        ushort ftw;
        ushort fop;
        c_ulong rip;
        c_ulong rdp;
        uint mxcsr;
        uint mxcr_mask;
        _fpxreg[8] _st;
        _xmmreg[16] _xmm;
        uint[24] __glibc_reserved1;
    }
    struct sigcontext
    {
        c_ulong r8;
        c_ulong r9;
        c_ulong r10;
        c_ulong r11;
        c_ulong r12;
        c_ulong r13;
        c_ulong r14;
        c_ulong r15;
        c_ulong rdi;
        c_ulong rsi;
        c_ulong rbp;
        c_ulong rbx;
        c_ulong rdx;
        c_ulong rax;
        c_ulong rcx;
        c_ulong rsp;
        c_ulong rip;
        c_ulong eflags;
        ushort cs;
        ushort gs;
        ushort fs;
        ushort __pad0;
        c_ulong err;
        c_ulong trapno;
        c_ulong oldmask;
        c_ulong cr2;
        static union _Anonymous_2
        {
            _fpstate* fpstate;
            c_ulong __fpstate_word;
        }
        _Anonymous_2 _anonymous_3;
        auto fpstate() @property @nogc pure nothrow { return _anonymous_3.fpstate; }
        void fpstate(_T_)(auto ref _T_ val) @property @nogc pure nothrow { _anonymous_3.fpstate = val; }
        auto __fpstate_word() @property @nogc pure nothrow { return _anonymous_3.__fpstate_word; }
        void __fpstate_word(_T_)(auto ref _T_ val) @property @nogc pure nothrow { _anonymous_3.__fpstate_word = val; }
        c_ulong[8] __reserved1;
    }
    struct _xsave_hdr
    {
        c_ulong xstate_bv;
        c_ulong[2] __glibc_reserved1;
        c_ulong[5] __glibc_reserved2;
    }
    struct _ymmh_state
    {
        uint[64] ymmh_space;
    }
    struct _xstate
    {
        _fpstate fpstate;
        _xsave_hdr xstate_hdr;
        _ymmh_state ymmh;
    }
    struct _ion_stream_paged;
    enum _Anonymous_4
    {
        SIGEV_SIGNAL = 0,
        SIGEV_NONE = 1,
        SIGEV_THREAD = 2,
        SIGEV_THREAD_ID = 4,
    }
    enum SIGEV_SIGNAL = _Anonymous_4.SIGEV_SIGNAL;
    enum SIGEV_NONE = _Anonymous_4.SIGEV_NONE;
    enum SIGEV_THREAD = _Anonymous_4.SIGEV_THREAD;
    enum SIGEV_THREAD_ID = _Anonymous_4.SIGEV_THREAD_ID;
    alias ION_STREAM_PAGED = _ion_stream_paged;
    struct _ion_stream_user_paged;
    alias ION_STREAM_USER_PAGED = _ion_stream_user_paged;
    enum _Anonymous_5
    {
        SI_ASYNCNL = -60,
        SI_DETHREAD = -7,
        SI_TKILL = -6,
        SI_SIGIO = -5,
        SI_ASYNCIO = -4,
        SI_MESGQ = -3,
        SI_TIMER = -2,
        SI_QUEUE = -1,
        SI_USER = 0,
        SI_KERNEL = 128,
    }
    enum SI_ASYNCNL = _Anonymous_5.SI_ASYNCNL;
    enum SI_DETHREAD = _Anonymous_5.SI_DETHREAD;
    enum SI_TKILL = _Anonymous_5.SI_TKILL;
    enum SI_SIGIO = _Anonymous_5.SI_SIGIO;
    enum SI_ASYNCIO = _Anonymous_5.SI_ASYNCIO;
    enum SI_MESGQ = _Anonymous_5.SI_MESGQ;
    enum SI_TIMER = _Anonymous_5.SI_TIMER;
    enum SI_QUEUE = _Anonymous_5.SI_QUEUE;
    enum SI_USER = _Anonymous_5.SI_USER;
    enum SI_KERNEL = _Anonymous_5.SI_KERNEL;
    ion_error_code ion_reader_close(_ion_reader*) @nogc nothrow;
    ion_error_code ion_reader_get_position(_ion_reader*, c_long*, int*, int*) @nogc nothrow;
    ion_error_code ion_reader_read_lob_partial_bytes(_ion_reader*, ubyte*, int, int*) @nogc nothrow;
    ion_error_code ion_reader_read_lob_bytes(_ion_reader*, ubyte*, int, int*) @nogc nothrow;
    ion_error_code ion_reader_get_lob_size(_ion_reader*, int*) @nogc nothrow;
    enum _Anonymous_6
    {
        ILL_ILLOPC = 1,
        ILL_ILLOPN = 2,
        ILL_ILLADR = 3,
        ILL_ILLTRP = 4,
        ILL_PRVOPC = 5,
        ILL_PRVREG = 6,
        ILL_COPROC = 7,
        ILL_BADSTK = 8,
        ILL_BADIADDR = 9,
    }
    enum ILL_ILLOPC = _Anonymous_6.ILL_ILLOPC;
    enum ILL_ILLOPN = _Anonymous_6.ILL_ILLOPN;
    enum ILL_ILLADR = _Anonymous_6.ILL_ILLADR;
    enum ILL_ILLTRP = _Anonymous_6.ILL_ILLTRP;
    enum ILL_PRVOPC = _Anonymous_6.ILL_PRVOPC;
    enum ILL_PRVREG = _Anonymous_6.ILL_PRVREG;
    enum ILL_COPROC = _Anonymous_6.ILL_COPROC;
    enum ILL_BADSTK = _Anonymous_6.ILL_BADSTK;
    enum ILL_BADIADDR = _Anonymous_6.ILL_BADIADDR;
    ion_error_code ion_reader_read_partial_string(_ion_reader*, ubyte*, int, int*) @nogc nothrow;
    ion_error_code ion_reader_read_string(_ion_reader*, _ion_string*) @nogc nothrow;
    ion_error_code ion_reader_get_string_length(_ion_reader*, int*) @nogc nothrow;
    ion_error_code ion_reader_read_ion_symbol(_ion_reader*, _ion_symbol*) @nogc nothrow;
    ion_error_code ion_reader_read_timestamp(_ion_reader*, _ion_timestamp*) @nogc nothrow;
    enum _Anonymous_7
    {
        FPE_INTDIV = 1,
        FPE_INTOVF = 2,
        FPE_FLTDIV = 3,
        FPE_FLTOVF = 4,
        FPE_FLTUND = 5,
        FPE_FLTRES = 6,
        FPE_FLTINV = 7,
        FPE_FLTSUB = 8,
        FPE_FLTUNK = 14,
        FPE_CONDTRAP = 15,
    }
    enum FPE_INTDIV = _Anonymous_7.FPE_INTDIV;
    enum FPE_INTOVF = _Anonymous_7.FPE_INTOVF;
    enum FPE_FLTDIV = _Anonymous_7.FPE_FLTDIV;
    enum FPE_FLTOVF = _Anonymous_7.FPE_FLTOVF;
    enum FPE_FLTUND = _Anonymous_7.FPE_FLTUND;
    enum FPE_FLTRES = _Anonymous_7.FPE_FLTRES;
    enum FPE_FLTINV = _Anonymous_7.FPE_FLTINV;
    enum FPE_FLTSUB = _Anonymous_7.FPE_FLTSUB;
    enum FPE_FLTUNK = _Anonymous_7.FPE_FLTUNK;
    enum FPE_CONDTRAP = _Anonymous_7.FPE_CONDTRAP;
    ion_error_code ion_reader_read_ion_decimal(_ion_reader*, _ion_decimal*) @nogc nothrow;
    ion_error_code ion_reader_read_decimal(_ion_reader*, decQuad*) @nogc nothrow;
    ion_error_code ion_reader_read_double(_ion_reader*, double*) @nogc nothrow;
    ion_error_code ion_reader_read_long(_ion_reader*, c_long*) @nogc nothrow;
    ion_error_code ion_reader_read_ion_int(_ion_reader*, _ion_int*) @nogc nothrow;
    enum _Anonymous_8
    {
        SEGV_MAPERR = 1,
        SEGV_ACCERR = 2,
        SEGV_BNDERR = 3,
        SEGV_PKUERR = 4,
        SEGV_ACCADI = 5,
        SEGV_ADIDERR = 6,
        SEGV_ADIPERR = 7,
    }
    enum SEGV_MAPERR = _Anonymous_8.SEGV_MAPERR;
    enum SEGV_ACCERR = _Anonymous_8.SEGV_ACCERR;
    enum SEGV_BNDERR = _Anonymous_8.SEGV_BNDERR;
    enum SEGV_PKUERR = _Anonymous_8.SEGV_PKUERR;
    enum SEGV_ACCADI = _Anonymous_8.SEGV_ACCADI;
    enum SEGV_ADIDERR = _Anonymous_8.SEGV_ADIDERR;
    enum SEGV_ADIPERR = _Anonymous_8.SEGV_ADIPERR;
    ion_error_code ion_reader_read_int64(_ion_reader*, c_long*) @nogc nothrow;
    ion_error_code ion_reader_read_int32(_ion_reader*, int*) @nogc nothrow;
    ion_error_code ion_reader_read_int(_ion_reader*, int*) @nogc nothrow;
    enum _Anonymous_9
    {
        BUS_ADRALN = 1,
        BUS_ADRERR = 2,
        BUS_OBJERR = 3,
        BUS_MCEERR_AR = 4,
        BUS_MCEERR_AO = 5,
    }
    enum BUS_ADRALN = _Anonymous_9.BUS_ADRALN;
    enum BUS_ADRERR = _Anonymous_9.BUS_ADRERR;
    enum BUS_OBJERR = _Anonymous_9.BUS_OBJERR;
    enum BUS_MCEERR_AR = _Anonymous_9.BUS_MCEERR_AR;
    enum BUS_MCEERR_AO = _Anonymous_9.BUS_MCEERR_AO;
    ion_error_code ion_reader_read_bool(_ion_reader*, int*) @nogc nothrow;
    ion_error_code ion_reader_read_null(_ion_reader*, ion_type**) @nogc nothrow;
    ion_error_code ion_reader_get_an_annotation_symbol(_ion_reader*, int, _ion_symbol*) @nogc nothrow;
    enum _Anonymous_10
    {
        CLD_EXITED = 1,
        CLD_KILLED = 2,
        CLD_DUMPED = 3,
        CLD_TRAPPED = 4,
        CLD_STOPPED = 5,
        CLD_CONTINUED = 6,
    }
    enum CLD_EXITED = _Anonymous_10.CLD_EXITED;
    enum CLD_KILLED = _Anonymous_10.CLD_KILLED;
    enum CLD_DUMPED = _Anonymous_10.CLD_DUMPED;
    enum CLD_TRAPPED = _Anonymous_10.CLD_TRAPPED;
    enum CLD_STOPPED = _Anonymous_10.CLD_STOPPED;
    enum CLD_CONTINUED = _Anonymous_10.CLD_CONTINUED;
    ion_error_code ion_reader_get_an_annotation(_ion_reader*, int, _ion_string*) @nogc nothrow;
    ion_error_code ion_reader_get_annotation_count(_ion_reader*, int*) @nogc nothrow;
    ion_error_code ion_reader_get_annotation_symbols(_ion_reader*, _ion_symbol*, int, int*) @nogc nothrow;
    enum _Anonymous_11
    {
        POLL_IN = 1,
        POLL_OUT = 2,
        POLL_MSG = 3,
        POLL_ERR = 4,
        POLL_PRI = 5,
        POLL_HUP = 6,
    }
    enum POLL_IN = _Anonymous_11.POLL_IN;
    enum POLL_OUT = _Anonymous_11.POLL_OUT;
    enum POLL_MSG = _Anonymous_11.POLL_MSG;
    enum POLL_ERR = _Anonymous_11.POLL_ERR;
    enum POLL_PRI = _Anonymous_11.POLL_PRI;
    enum POLL_HUP = _Anonymous_11.POLL_HUP;
    ion_error_code ion_reader_get_annotations(_ion_reader*, _ion_string*, int, int*) @nogc nothrow;
    ion_error_code ion_reader_get_field_name_symbol(_ion_reader*, _ion_symbol**) @nogc nothrow;
    ion_error_code ion_reader_get_field_name(_ion_reader*, _ion_string*) @nogc nothrow;
    ion_error_code ion_reader_is_in_struct(_ion_reader*, int*) @nogc nothrow;
    ion_error_code ion_reader_is_null(_ion_reader*, int*) @nogc nothrow;
    ion_error_code ion_reader_has_annotation(_ion_reader*, _ion_string*, int*) @nogc nothrow;
    ion_error_code ion_reader_has_any_annotations(_ion_reader*, int*) @nogc nothrow;
    ion_error_code ion_reader_get_type(_ion_reader*, ion_type**) @nogc nothrow;
    ion_error_code ion_reader_get_depth(_ion_reader*, int*) @nogc nothrow;
    ion_error_code ion_reader_step_out(_ion_reader*) @nogc nothrow;
    ion_error_code ion_reader_step_in(_ion_reader*) @nogc nothrow;
    ion_error_code ion_reader_next(_ion_reader*, ion_type**) @nogc nothrow;
    ion_error_code ion_reader_get_symbol_table(_ion_reader*, _ion_symbol_table**) @nogc nothrow;
    ion_error_code ion_reader_get_value_length(_ion_reader*, int*) @nogc nothrow;
    ion_error_code ion_reader_get_value_offset(_ion_reader*, c_long*) @nogc nothrow;
    ion_error_code ion_reader_set_symbol_table(_ion_reader*, _ion_symbol_table*) @nogc nothrow;
    ion_error_code ion_reader_seek(_ion_reader*, c_long, int) @nogc nothrow;
    ion_error_code ion_reader_get_catalog(_ion_reader*, _ion_catalog**) @nogc nothrow;
    ion_error_code ion_reader_open(_ion_reader**, _ion_stream*, _ion_reader_options*) @nogc nothrow;
    ion_error_code ion_reader_reset_stream_with_length(_ion_reader**, void*, ion_error_code function(_ion_user_stream*), c_long) @nogc nothrow;
    ion_error_code ion_reader_reset_stream(_ion_reader**, void*, ion_error_code function(_ion_user_stream*)) @nogc nothrow;
    ion_error_code ion_reader_open_stream(_ion_reader**, void*, ion_error_code function(_ion_user_stream*), _ion_reader_options*) @nogc nothrow;
    ion_error_code ion_reader_open_buffer(_ion_reader**, ubyte*, int, _ion_reader_options*) @nogc nothrow;
    struct _ion_reader_options
    {
        int return_system_values;
        int new_line_char;
        int max_container_depth;
        int max_annotation_count;
        int max_annotation_buffered;
        int symbol_threshold;
        int user_value_threshold;
        int chunk_threshold;
        int allocation_page_size;
        int skip_character_validation;
        _ion_catalog* pcatalog;
        decContext* decimal_context;
        _ion_reader_context_change_notifier context_change_notifier;
    }
    alias ION_READER_OPTIONS = _ion_reader_options;
    struct _ion_reader_context_change_notifier
    {
        ion_error_code function(void*, _ion_collection*) notify;
        void* context;
    }
    alias ION_READER_CONTEXT_CHANGE_NOTIFIER = _ion_reader_context_change_notifier;
    alias ION_READER_CONTEXT_CALLBACK = ion_error_code function(void*, _ion_collection*);
    ion_error_code _ion_int_divide_by_digit(uint*, int, uint, uint*) @nogc nothrow;
    ion_error_code _ion_int_multiply_and_add(uint*, int, uint, uint) @nogc nothrow;
    ion_error_code _ion_int_sub_digit(uint*, int, uint) @nogc nothrow;
    ion_error_code _ion_int_add_digit(uint*, int, uint) @nogc nothrow;
    ion_error_code _ion_int_to_int64_helper(_ion_int*, c_long*) @nogc nothrow;
    int _ion_int_abs_bytes_signed_length_helper(const(_ion_int)*) @nogc nothrow;
    int _ion_int_abs_bytes_length_helper(const(_ion_int)*) @nogc nothrow;
    ion_error_code _ion_int_to_bytes_helper(_ion_int*, int, int, int, ubyte*, int, int*) @nogc nothrow;
    int pthread_sigmask(int, const(__sigset_t)*, __sigset_t*) @nogc nothrow;
    int pthread_kill(c_ulong, int) @nogc nothrow;
    int _ion_int_bytes_length_helper(const(_ion_int)*) @nogc nothrow;
    enum _Anonymous_12
    {
        SS_ONSTACK = 1,
        SS_DISABLE = 2,
    }
    enum SS_ONSTACK = _Anonymous_12.SS_ONSTACK;
    enum SS_DISABLE = _Anonymous_12.SS_DISABLE;
    int _ion_int_is_high_bytes_high_bit_set_helper(const(_ion_int)*, int) @nogc nothrow;
    ion_error_code _ion_int_to_string_helper(_ion_int*, char*, int, int*) @nogc nothrow;
    int _ion_int_get_char_len_helper(const(_ion_int)*) @nogc nothrow;
    alias int8_t = byte;
    alias int16_t = short;
    alias int32_t = int;
    alias int64_t = c_long;
    int _ion_int_highest_bit_set_helper(const(_ion_int)*) @nogc nothrow;
    alias uint8_t = ubyte;
    alias uint16_t = ushort;
    alias uint32_t = uint;
    alias uint64_t = ulong;
    int _ion_int_is_zero_bytes(const(uint)*, int) @nogc nothrow;
    int _ion_int_is_zero(const(_ion_int)*) @nogc nothrow;
    int _ion_int_is_null_helper(const(_ion_int)*) @nogc nothrow;
    ion_error_code _ion_int_from_binary_chars_helper(_ion_int*, const(char)*, int) @nogc nothrow;
    ion_error_code _ion_int_from_hex_chars_helper(_ion_int*, const(char)*, int) @nogc nothrow;
    ion_error_code _ion_int_from_radix_chars_helper(_ion_int*, const(char)*, int, uint*, uint, uint, const(char)*) @nogc nothrow;
    ion_error_code _ion_int_from_chars_helper(_ion_int*, const(char)*, int) @nogc nothrow;
    struct __pthread_mutex_s
    {
        int __lock;
        uint __count;
        int __owner;
        uint __nusers;
        int __kind;
        short __spins;
        short __elision;
        __pthread_internal_list __list;
    }
    int _ion_int_from_bytes_helper(_ion_int*, ubyte*, int, int, int, int) @nogc nothrow;
    void _ion_int_free_temp(uint*, uint*) @nogc nothrow;
    uint* _ion_int_buffer_temp_copy(uint*, int, uint*, int) @nogc nothrow;
    struct __pthread_rwlock_arch_t
    {
        uint __readers;
        uint __writers;
        uint __wrphase_futex;
        uint __writers_futex;
        uint __pad3;
        uint __pad4;
        int __cur_writer;
        int __shared;
        byte __rwelision;
        ubyte[7] __pad1;
        c_ulong __pad2;
        uint __flags;
    }
    ion_error_code _ion_int_extend_digits(_ion_int*, int, int) @nogc nothrow;
    void* _ion_int_realloc_helper(void*, int, void*, int) @nogc nothrow;
    extern __gshared int sys_nerr;
    extern __gshared const(const(char)*)[0] sys_errlist;
    ion_error_code _ion_int_zero(_ion_int*) @nogc nothrow;
    alias __pthread_list_t = __pthread_internal_list;
    struct __pthread_internal_list
    {
        __pthread_internal_list* __prev;
        __pthread_internal_list* __next;
    }
    alias __pthread_slist_t = __pthread_internal_slist;
    struct __pthread_internal_slist
    {
        __pthread_internal_slist* __next;
    }
    struct __pthread_cond_s
    {
        static union _Anonymous_13
        {
            ulong __wseq;
            static struct _Anonymous_14
            {
                uint __low;
                uint __high;
            }
            _Anonymous_14 __wseq32;
        }
        _Anonymous_13 _anonymous_15;
        auto __wseq() @property @nogc pure nothrow { return _anonymous_15.__wseq; }
        void __wseq(_T_)(auto ref _T_ val) @property @nogc pure nothrow { _anonymous_15.__wseq = val; }
        auto __wseq32() @property @nogc pure nothrow { return _anonymous_15.__wseq32; }
        void __wseq32(_T_)(auto ref _T_ val) @property @nogc pure nothrow { _anonymous_15.__wseq32 = val; }
        static union _Anonymous_16
        {
            ulong __g1_start;
            static struct _Anonymous_17
            {
                uint __low;
                uint __high;
            }
            _Anonymous_17 __g1_start32;
        }
        _Anonymous_16 _anonymous_18;
        auto __g1_start() @property @nogc pure nothrow { return _anonymous_18.__g1_start; }
        void __g1_start(_T_)(auto ref _T_ val) @property @nogc pure nothrow { _anonymous_18.__g1_start = val; }
        auto __g1_start32() @property @nogc pure nothrow { return _anonymous_18.__g1_start32; }
        void __g1_start32(_T_)(auto ref _T_ val) @property @nogc pure nothrow { _anonymous_18.__g1_start32 = val; }
        uint[2] __g_refs;
        uint[2] __g_size;
        uint __g1_orig_size;
        uint __wrefs;
        uint[2] __g_signals;
    }
    void _ion_int_init(_ion_int*, void*) @nogc nothrow;
    ion_error_code _ion_int_validate_non_null_arg_with_ptr(const(_ion_int)*, const(void)*) @nogc nothrow;
    ion_error_code _ion_int_validate_arg_with_ptr(const(_ion_int)*, const(void)*) @nogc nothrow;
    ion_error_code _ion_int_validate_arg(const(_ion_int)*) @nogc nothrow;
    ion_error_code _ion_int_to_decimal_number(_ion_int*, decNumber*, decContext*) @nogc nothrow;
    ion_error_code _ion_int_from_decimal_number(_ion_int*, const(decNumber)*, decContext*) @nogc nothrow;
    int _ion_int_init_globals() @nogc nothrow;
    void _ion_int_dump_quad(decQuad*, c_long) @nogc nothrow;
    ion_error_code ion_int_to_decimal(_ion_int*, decQuad*, decContext*) @nogc nothrow;
    ion_error_code ion_int_to_int32(_ion_int*, int*) @nogc nothrow;
    ion_error_code ion_int_to_int64(_ion_int*, c_long*) @nogc nothrow;
    ion_error_code ion_int_to_abs_bytes(_ion_int*, int, ubyte*, int, int*) @nogc nothrow;
    ion_error_code ion_int_abs_bytes_length(_ion_int*, int*) @nogc nothrow;
    alias __u_char = ubyte;
    alias __u_short = ushort;
    alias __u_int = uint;
    alias __u_long = c_ulong;
    alias __int8_t = byte;
    alias __uint8_t = ubyte;
    alias __int16_t = short;
    alias __uint16_t = ushort;
    alias __int32_t = int;
    alias __uint32_t = uint;
    alias __int64_t = c_long;
    alias __uint64_t = c_ulong;
    alias __int_least8_t = byte;
    alias __uint_least8_t = ubyte;
    alias __int_least16_t = short;
    alias __uint_least16_t = ushort;
    alias __int_least32_t = int;
    alias __uint_least32_t = uint;
    alias __int_least64_t = c_long;
    alias __uint_least64_t = c_ulong;
    alias __quad_t = c_long;
    alias __u_quad_t = c_ulong;
    alias __intmax_t = c_long;
    alias __uintmax_t = c_ulong;
    ion_error_code ion_int_to_bytes(_ion_int*, int, ubyte*, int, int*) @nogc nothrow;
    ion_error_code ion_int_byte_length(_ion_int*, int*) @nogc nothrow;
    ion_error_code ion_int_to_string(_ion_int*, void*, _ion_string*) @nogc nothrow;
    ion_error_code ion_int_to_char(_ion_int*, ubyte*, int, int*) @nogc nothrow;
    ion_error_code ion_int_char_length(_ion_int*, int*) @nogc nothrow;
    ion_error_code ion_int_from_decimal(_ion_int*, const(decQuad)*, decContext*) @nogc nothrow;
    ion_error_code ion_int_from_long(_ion_int*, c_long) @nogc nothrow;
    ion_error_code ion_int_from_abs_bytes(_ion_int*, ubyte*, int, int) @nogc nothrow;
    alias __dev_t = c_ulong;
    alias __uid_t = uint;
    alias __gid_t = uint;
    alias __ino_t = c_ulong;
    alias __ino64_t = c_ulong;
    alias __mode_t = uint;
    alias __nlink_t = c_ulong;
    alias __off_t = c_long;
    alias __off64_t = c_long;
    alias __pid_t = int;
    struct __fsid_t
    {
        int[2] __val;
    }
    alias __clock_t = c_long;
    alias __rlim_t = c_ulong;
    alias __rlim64_t = c_ulong;
    alias __id_t = uint;
    alias __time_t = c_long;
    alias __useconds_t = uint;
    alias __suseconds_t = c_long;
    alias __daddr_t = int;
    alias __key_t = int;
    alias __clockid_t = int;
    alias __timer_t = void*;
    alias __blksize_t = c_long;
    alias __blkcnt_t = c_long;
    alias __blkcnt64_t = c_long;
    alias __fsblkcnt_t = c_ulong;
    alias __fsblkcnt64_t = c_ulong;
    alias __fsfilcnt_t = c_ulong;
    alias __fsfilcnt64_t = c_ulong;
    alias __fsword_t = c_long;
    alias __ssize_t = c_long;
    alias __syscall_slong_t = c_long;
    alias __syscall_ulong_t = c_ulong;
    alias __loff_t = c_long;
    alias __caddr_t = char*;
    alias __intptr_t = c_long;
    alias __socklen_t = uint;
    alias __sig_atomic_t = int;
    alias FILE = _IO_FILE;
    ion_error_code ion_int_from_bytes(_ion_int*, ubyte*, int) @nogc nothrow;
    struct _IO_FILE
    {
        int _flags;
        char* _IO_read_ptr;
        char* _IO_read_end;
        char* _IO_read_base;
        char* _IO_write_base;
        char* _IO_write_ptr;
        char* _IO_write_end;
        char* _IO_buf_base;
        char* _IO_buf_end;
        char* _IO_save_base;
        char* _IO_backup_base;
        char* _IO_save_end;
        _IO_marker* _markers;
        _IO_FILE* _chain;
        int _fileno;
        int _flags2;
        c_long _old_offset;
        ushort _cur_column;
        byte _vtable_offset;
        char[1] _shortbuf;
        void* _lock;
        c_long _offset;
        _IO_codecvt* _codecvt;
        _IO_wide_data* _wide_data;
        _IO_FILE* _freeres_list;
        void* _freeres_buf;
        c_ulong __pad5;
        int _mode;
        char[20] _unused2;
    }
    alias __FILE = _IO_FILE;
    alias __fpos64_t = _G_fpos64_t;
    struct _G_fpos64_t
    {
        c_long __pos;
        __mbstate_t __state;
    }
    ion_error_code ion_int_from_binary_chars(_ion_int*, const(char)*, int) @nogc nothrow;
    alias __fpos_t = _G_fpos_t;
    struct _G_fpos_t
    {
        c_long __pos;
        __mbstate_t __state;
    }
    struct __locale_struct
    {
        __locale_data*[13] __locales;
        const(ushort)* __ctype_b;
        const(int)* __ctype_tolower;
        const(int)* __ctype_toupper;
        const(char)*[13] __names;
    }
    alias __locale_t = __locale_struct*;
    ion_error_code ion_int_from_hex_chars(_ion_int*, const(char)*, int) @nogc nothrow;
    struct __mbstate_t
    {
        int __count;
        static union _Anonymous_19
        {
            uint __wch;
            char[4] __wchb;
        }
        _Anonymous_19 __value;
    }
    struct __sigset_t
    {
        c_ulong[16] __val;
    }
    ion_error_code ion_int_from_chars(_ion_int*, const(char)*, int) @nogc nothrow;
    union sigval
    {
        int sival_int;
        void* sival_ptr;
    }
    alias __sigval_t = sigval;
    ion_error_code ion_int_from_binary_string(_ion_int*, const(_ion_string*)) @nogc nothrow;
    alias clock_t = c_long;
    alias clockid_t = int;
    ion_error_code ion_int_from_hex_string(_ion_int*, const(_ion_string*)) @nogc nothrow;
    alias locale_t = __locale_struct*;
    alias sig_atomic_t = int;
    ion_error_code ion_int_from_string(_ion_int*, const(_ion_string*)) @nogc nothrow;
    ion_error_code ion_int_highest_bit_set(_ion_int*, int*) @nogc nothrow;
    union pthread_attr_t
    {
        char[56] __size;
        c_long __align;
    }
    alias sigevent_t = sigevent;
    struct sigevent
    {
        sigval sigev_value;
        int sigev_signo;
        int sigev_notify;
        static union _Anonymous_20
        {
            int[12] _pad;
            int _tid;
            static struct _Anonymous_21
            {
                void function(sigval) _function;
                pthread_attr_t* _attribute;
            }
            _Anonymous_21 _sigev_thread;
        }
        _Anonymous_20 _sigev_un;
    }
    ion_error_code ion_int_signum(_ion_int*, int*) @nogc nothrow;
    ion_error_code ion_int_compare(_ion_int*, _ion_int*, int*) @nogc nothrow;
    ion_error_code ion_int_is_zero(_ion_int*, int*) @nogc nothrow;
    ion_error_code ion_int_is_null(_ion_int*, int*) @nogc nothrow;
    ion_error_code ion_int_copy(_ion_int*, _ion_int*, void*) @nogc nothrow;
    struct siginfo_t
    {
        int si_signo;
        int si_errno;
        int si_code;
        int __pad0;
        static union _Anonymous_22
        {
            int[28] _pad;
            static struct _Anonymous_23
            {
                int si_pid;
                uint si_uid;
            }
            _Anonymous_23 _kill;
            static struct _Anonymous_24
            {
                int si_tid;
                int si_overrun;
                sigval si_sigval;
            }
            _Anonymous_24 _timer;
            static struct _Anonymous_25
            {
                int si_pid;
                uint si_uid;
                sigval si_sigval;
            }
            _Anonymous_25 _rt;
            static struct _Anonymous_26
            {
                int si_pid;
                uint si_uid;
                int si_status;
                c_long si_utime;
                c_long si_stime;
            }
            _Anonymous_26 _sigchld;
            static struct _Anonymous_27
            {
                void* si_addr;
                short si_addr_lsb;
                static union _Anonymous_28
                {
                    static struct _Anonymous_29
                    {
                        void* _lower;
                        void* _upper;
                    }
                    _Anonymous_29 _addr_bnd;
                    uint _pkey;
                }
                _Anonymous_28 _bounds;
            }
            _Anonymous_27 _sigfault;
            static struct _Anonymous_30
            {
                c_long si_band;
                int si_fd;
            }
            _Anonymous_30 _sigpoll;
            static struct _Anonymous_31
            {
                void* _call_addr;
                int _syscall;
                uint _arch;
            }
            _Anonymous_31 _sigsys;
        }
        _Anonymous_22 _sifields;
    }
    ion_error_code ion_int_init(_ion_int*, void*) @nogc nothrow;
    void ion_int_free(_ion_int*) @nogc nothrow;
    ion_error_code ion_int_alloc(void*, _ion_int**) @nogc nothrow;
    extern __gshared decNumber g_digit_base_number;
    extern __gshared decQuad g_digit_base_quad;
    extern __gshared int g_ion_int_globals_initialized;
    extern __gshared _ion_int g_Int_Null;
    extern __gshared _ion_int g_Int_Zero;
    extern __gshared uint[0] g_int_zero_bytes;
    alias sigset_t = __sigset_t;
    alias II_LONG_DIGIT = c_ulong;
    alias sigval_t = sigval;
    alias II_DIGIT = uint;
    struct stack_t
    {
        void* ss_sp;
        int ss_flags;
        c_ulong ss_size;
    }
    struct _IO_marker;
    struct _IO_codecvt;
    struct _IO_wide_data;
    alias _IO_lock_t = void;
    int ion_float_is_negative_zero(double) @nogc nothrow;
    const(char)* ion_error_to_str(ion_error_code) @nogc nothrow;
    alias iERR = ion_error_code;
    struct itimerspec
    {
        timespec it_interval;
        timespec it_value;
    }
    struct sigstack
    {
        void* ss_sp;
        int ss_onstack;
    }
    enum ion_error_code
    {
        IERR_NOT_IMPL = -1,
        IERR_OK = 0,
        IERR_BAD_HANDLE = 1,
        IERR_INVALID_ARG = 2,
        IERR_NO_MEMORY = 3,
        IERR_EOF = 4,
        IERR_INVALID_STATE = 5,
        IERR_TOO_MANY_ANNOTATIONS = 6,
        IERR_UNRECOGNIZED_FLOAT = 7,
        IERR_NULL_VALUE = 8,
        IERR_BUFFER_TOO_SMALL = 9,
        IERR_INVALID_TIMESTAMP = 10,
        IERR_INVALID_UNICODE_SEQUENCE = 12,
        IERR_UNREAD_LIMIT_EXCEEDED = 13,
        IERR_INVALID_TOKEN = 14,
        IERR_INVALID_UTF8 = 15,
        IERR_LOOKAHEAD_OVERFLOW = 16,
        IERR_BAD_BASE64_BLOB = 17,
        IERR_TOKEN_TOO_LONG = 18,
        IERR_INVALID_UTF8_CHAR = 19,
        IERR_UNEXPECTED_EOF = 20,
        IERR_INVALID_ESCAPE_SEQUENCE = 21,
        IERR_INVALID_SYNTAX = 22,
        IERR_INVALID_TOKEN_CHAR = 23,
        IERR_INVALID_SYMBOL = 24,
        IERR_STACK_UNDERFLOW = 25,
        IERR_INVALID_SYMBOL_LIST = 26,
        IERR_PARSER_INTERNAL = 27,
        IERR_INVALID_SYMBOL_TABLE = 28,
        IERR_IS_IMMUTABLE = 29,
        IERR_DUPLICATE_SYMBOL = 30,
        IERR_DUPLICATE_SYMBOL_ID = 31,
        IERR_NO_SUCH_ELEMENT = 32,
        IERR_INVALID_FIELDNAME = 33,
        IERR_INVALID_BINARY = 34,
        IERR_IMPORT_NOT_FOUND = 35,
        IERR_NUMERIC_OVERFLOW = 36,
        IERR_INVALID_ION_VERSION = 37,
        IERR_ENTRY_NOT_FOUND = 38,
        IERR_CANT_FIND_FILE = 39,
        IERR_STREAM_FAILED = 40,
        IERR_KEY_ALREADY_EXISTS = 41,
        IERR_KEY_NOT_FOUND = 42,
        IERR_KEY_ADDED = 43,
        IERR_HAS_LOCAL_SYMBOLS = 44,
        IERR_NOT_A_SYMBOL_TABLE = 45,
        IERR_MARK_NOT_SET = 46,
        IERR_WRITE_ERROR = 47,
        IERR_SEEK_ERROR = 48,
        IERR_READ_ERROR = 49,
        IERR_INTERNAL_ERROR = 50,
        IERR_NEW_LINE_IN_STRING = 51,
        IERR_INVALID_LEADING_ZEROS = 52,
        IERR_INVALID_LOB_TERMINATOR = 53,
        IERR_MAX_ERROR_CODE = 54,
    }
    enum IERR_NOT_IMPL = ion_error_code.IERR_NOT_IMPL;
    enum IERR_OK = ion_error_code.IERR_OK;
    enum IERR_BAD_HANDLE = ion_error_code.IERR_BAD_HANDLE;
    enum IERR_INVALID_ARG = ion_error_code.IERR_INVALID_ARG;
    enum IERR_NO_MEMORY = ion_error_code.IERR_NO_MEMORY;
    enum IERR_EOF = ion_error_code.IERR_EOF;
    enum IERR_INVALID_STATE = ion_error_code.IERR_INVALID_STATE;
    enum IERR_TOO_MANY_ANNOTATIONS = ion_error_code.IERR_TOO_MANY_ANNOTATIONS;
    enum IERR_UNRECOGNIZED_FLOAT = ion_error_code.IERR_UNRECOGNIZED_FLOAT;
    enum IERR_NULL_VALUE = ion_error_code.IERR_NULL_VALUE;
    enum IERR_BUFFER_TOO_SMALL = ion_error_code.IERR_BUFFER_TOO_SMALL;
    enum IERR_INVALID_TIMESTAMP = ion_error_code.IERR_INVALID_TIMESTAMP;
    enum IERR_INVALID_UNICODE_SEQUENCE = ion_error_code.IERR_INVALID_UNICODE_SEQUENCE;
    enum IERR_UNREAD_LIMIT_EXCEEDED = ion_error_code.IERR_UNREAD_LIMIT_EXCEEDED;
    enum IERR_INVALID_TOKEN = ion_error_code.IERR_INVALID_TOKEN;
    enum IERR_INVALID_UTF8 = ion_error_code.IERR_INVALID_UTF8;
    enum IERR_LOOKAHEAD_OVERFLOW = ion_error_code.IERR_LOOKAHEAD_OVERFLOW;
    enum IERR_BAD_BASE64_BLOB = ion_error_code.IERR_BAD_BASE64_BLOB;
    enum IERR_TOKEN_TOO_LONG = ion_error_code.IERR_TOKEN_TOO_LONG;
    enum IERR_INVALID_UTF8_CHAR = ion_error_code.IERR_INVALID_UTF8_CHAR;
    enum IERR_UNEXPECTED_EOF = ion_error_code.IERR_UNEXPECTED_EOF;
    enum IERR_INVALID_ESCAPE_SEQUENCE = ion_error_code.IERR_INVALID_ESCAPE_SEQUENCE;
    enum IERR_INVALID_SYNTAX = ion_error_code.IERR_INVALID_SYNTAX;
    enum IERR_INVALID_TOKEN_CHAR = ion_error_code.IERR_INVALID_TOKEN_CHAR;
    enum IERR_INVALID_SYMBOL = ion_error_code.IERR_INVALID_SYMBOL;
    enum IERR_STACK_UNDERFLOW = ion_error_code.IERR_STACK_UNDERFLOW;
    enum IERR_INVALID_SYMBOL_LIST = ion_error_code.IERR_INVALID_SYMBOL_LIST;
    enum IERR_PARSER_INTERNAL = ion_error_code.IERR_PARSER_INTERNAL;
    enum IERR_INVALID_SYMBOL_TABLE = ion_error_code.IERR_INVALID_SYMBOL_TABLE;
    enum IERR_IS_IMMUTABLE = ion_error_code.IERR_IS_IMMUTABLE;
    enum IERR_DUPLICATE_SYMBOL = ion_error_code.IERR_DUPLICATE_SYMBOL;
    enum IERR_DUPLICATE_SYMBOL_ID = ion_error_code.IERR_DUPLICATE_SYMBOL_ID;
    enum IERR_NO_SUCH_ELEMENT = ion_error_code.IERR_NO_SUCH_ELEMENT;
    enum IERR_INVALID_FIELDNAME = ion_error_code.IERR_INVALID_FIELDNAME;
    enum IERR_INVALID_BINARY = ion_error_code.IERR_INVALID_BINARY;
    enum IERR_IMPORT_NOT_FOUND = ion_error_code.IERR_IMPORT_NOT_FOUND;
    enum IERR_NUMERIC_OVERFLOW = ion_error_code.IERR_NUMERIC_OVERFLOW;
    enum IERR_INVALID_ION_VERSION = ion_error_code.IERR_INVALID_ION_VERSION;
    enum IERR_ENTRY_NOT_FOUND = ion_error_code.IERR_ENTRY_NOT_FOUND;
    enum IERR_CANT_FIND_FILE = ion_error_code.IERR_CANT_FIND_FILE;
    enum IERR_STREAM_FAILED = ion_error_code.IERR_STREAM_FAILED;
    enum IERR_KEY_ALREADY_EXISTS = ion_error_code.IERR_KEY_ALREADY_EXISTS;
    enum IERR_KEY_NOT_FOUND = ion_error_code.IERR_KEY_NOT_FOUND;
    enum IERR_KEY_ADDED = ion_error_code.IERR_KEY_ADDED;
    enum IERR_HAS_LOCAL_SYMBOLS = ion_error_code.IERR_HAS_LOCAL_SYMBOLS;
    enum IERR_NOT_A_SYMBOL_TABLE = ion_error_code.IERR_NOT_A_SYMBOL_TABLE;
    enum IERR_MARK_NOT_SET = ion_error_code.IERR_MARK_NOT_SET;
    enum IERR_WRITE_ERROR = ion_error_code.IERR_WRITE_ERROR;
    enum IERR_SEEK_ERROR = ion_error_code.IERR_SEEK_ERROR;
    enum IERR_READ_ERROR = ion_error_code.IERR_READ_ERROR;
    enum IERR_INTERNAL_ERROR = ion_error_code.IERR_INTERNAL_ERROR;
    enum IERR_NEW_LINE_IN_STRING = ion_error_code.IERR_NEW_LINE_IN_STRING;
    enum IERR_INVALID_LEADING_ZEROS = ion_error_code.IERR_INVALID_LEADING_ZEROS;
    enum IERR_INVALID_LOB_TERMINATOR = ion_error_code.IERR_INVALID_LOB_TERMINATOR;
    enum IERR_MAX_ERROR_CODE = ion_error_code.IERR_MAX_ERROR_CODE;
    struct timespec
    {
        c_long tv_sec;
        c_long tv_nsec;
    }
    struct tm
    {
        int tm_sec;
        int tm_min;
        int tm_hour;
        int tm_mday;
        int tm_mon;
        int tm_year;
        int tm_wday;
        int tm_yday;
        int tm_isdst;
        c_long tm_gmtoff;
        const(char)* tm_zone;
    }
    alias time_t = c_long;
    alias timer_t = void*;
    ion_error_code ion_decimal_copy_sign(_ion_decimal*, const(_ion_decimal)*, const(_ion_decimal)*, decContext*) @nogc nothrow;
    ion_error_code ion_decimal_copy_negate(_ion_decimal*, const(_ion_decimal)*) @nogc nothrow;
    ion_error_code ion_decimal_copy_abs(_ion_decimal*, const(_ion_decimal)*) @nogc nothrow;
    ion_error_code ion_decimal_copy(_ion_decimal*, const(_ion_decimal)*) @nogc nothrow;
    ion_error_code ion_decimal_canonical(_ion_decimal*, const(_ion_decimal)*) @nogc nothrow;
    ion_error_code ion_decimal_equals(const(_ion_decimal)*, const(_ion_decimal)*, decContext*, int*) @nogc nothrow;
    ion_error_code ion_decimal_equals_quad(const(decQuad)*, const(decQuad)*, decContext*, int*) @nogc nothrow;
    ion_error_code ion_decimal_compare(const(_ion_decimal)*, const(_ion_decimal)*, decContext*, int*) @nogc nothrow;
    uint ion_decimal_is_canonical(const(_ion_decimal)*) @nogc nothrow;
    uint ion_decimal_is_zero(const(_ion_decimal)*) @nogc nothrow;
    uint ion_decimal_is_negative(const(_ion_decimal)*) @nogc nothrow;
    uint ion_decimal_is_nan(const(_ion_decimal)*) @nogc nothrow;
    uint ion_decimal_is_infinite(const(_ion_decimal)*) @nogc nothrow;
    uint ion_decimal_is_finite(const(_ion_decimal)*) @nogc nothrow;
    uint ion_decimal_is_normal(const(_ion_decimal)*, decContext*) @nogc nothrow;
    uint ion_decimal_is_subnormal(const(_ion_decimal)*, decContext*) @nogc nothrow;
    uint ion_decimal_is_integer(const(_ion_decimal)*) @nogc nothrow;
    uint ion_decimal_same_quantum(const(_ion_decimal)*, const(_ion_decimal)*) @nogc nothrow;
    uint ion_decimal_radix(const(_ion_decimal)*) @nogc nothrow;
    int ion_decimal_get_exponent(const(_ion_decimal)*) @nogc nothrow;
    uint ion_decimal_digits(const(_ion_decimal)*) @nogc nothrow;
    ion_error_code ion_decimal_to_integral_value(_ion_decimal*, const(_ion_decimal)*, decContext*) @nogc nothrow;
    ion_error_code ion_decimal_to_integral_exact(_ion_decimal*, const(_ion_decimal)*, decContext*) @nogc nothrow;
    ion_error_code ion_decimal_reduce(_ion_decimal*, const(_ion_decimal)*, decContext*) @nogc nothrow;
    ion_error_code ion_decimal_plus(_ion_decimal*, const(_ion_decimal)*, decContext*) @nogc nothrow;
    ion_error_code ion_decimal_minus(_ion_decimal*, const(_ion_decimal)*, decContext*) @nogc nothrow;
    alias pid_t = int;
    alias uid_t = uint;
    ion_error_code ion_decimal_logb(_ion_decimal*, const(_ion_decimal)*, decContext*) @nogc nothrow;
    alias __sighandler_t = void function(int);
    void function(int) __sysv_signal(int, void function(int)) @nogc nothrow;
    void function(int) signal(int, void function(int)) @nogc nothrow;
    int kill(int, int) @nogc nothrow;
    int killpg(int, int) @nogc nothrow;
    int raise(int) @nogc nothrow;
    void function(int) ssignal(int, void function(int)) @nogc nothrow;
    int gsignal(int) @nogc nothrow;
    void psignal(int, const(char)*) @nogc nothrow;
    void psiginfo(const(siginfo_t)*, const(char)*) @nogc nothrow;
    int sigblock(int) @nogc nothrow;
    int sigsetmask(int) @nogc nothrow;
    int siggetmask() @nogc nothrow;
    alias sig_t = void function(int);
    int sigemptyset(__sigset_t*) @nogc nothrow;
    int sigfillset(__sigset_t*) @nogc nothrow;
    int sigaddset(__sigset_t*, int) @nogc nothrow;
    int sigdelset(__sigset_t*, int) @nogc nothrow;
    int sigismember(const(__sigset_t)*, int) @nogc nothrow;
    int sigprocmask(int, const(__sigset_t)*, __sigset_t*) @nogc nothrow;
    int sigsuspend(const(__sigset_t)*) @nogc nothrow;
    pragma(mangle, "sigaction") int sigaction_(int, const(sigaction)*, sigaction*) @nogc nothrow;
    int sigpending(__sigset_t*) @nogc nothrow;
    int sigwait(const(__sigset_t)*, int*) @nogc nothrow;
    int sigwaitinfo(const(__sigset_t)*, siginfo_t*) @nogc nothrow;
    int sigtimedwait(const(__sigset_t)*, siginfo_t*, const(timespec)*) @nogc nothrow;
    int sigqueue(int, int, const(sigval)) @nogc nothrow;
    extern __gshared const(const(char)*)[65] _sys_siglist;
    extern __gshared const(const(char)*)[65] sys_siglist;
    int sigreturn(sigcontext*) @nogc nothrow;
    ion_error_code ion_decimal_invert(_ion_decimal*, const(_ion_decimal)*, decContext*) @nogc nothrow;
    int siginterrupt(int, int) @nogc nothrow;
    int sigaltstack(const(stack_t)*, stack_t*) @nogc nothrow;
    pragma(mangle, "sigstack") int sigstack_(sigstack*, sigstack*) @nogc nothrow;
    int __libc_current_sigrtmin() @nogc nothrow;
    int __libc_current_sigrtmax() @nogc nothrow;
    ion_error_code ion_decimal_abs(_ion_decimal*, const(_ion_decimal)*, decContext*) @nogc nothrow;
    ion_error_code ion_decimal_xor(_ion_decimal*, const(_ion_decimal)*, const(_ion_decimal)*, decContext*) @nogc nothrow;
    ion_error_code ion_decimal_subtract(_ion_decimal*, const(_ion_decimal)*, const(_ion_decimal)*, decContext*) @nogc nothrow;
    ion_error_code ion_decimal_shift(_ion_decimal*, const(_ion_decimal)*, const(_ion_decimal)*, decContext*) @nogc nothrow;
    alias int_least8_t = byte;
    alias int_least16_t = short;
    alias int_least32_t = int;
    alias int_least64_t = c_long;
    alias uint_least8_t = ubyte;
    alias uint_least16_t = ushort;
    alias uint_least32_t = uint;
    alias uint_least64_t = c_ulong;
    alias int_fast8_t = byte;
    alias int_fast16_t = c_long;
    alias int_fast32_t = c_long;
    alias int_fast64_t = c_long;
    alias uint_fast8_t = ubyte;
    alias uint_fast16_t = c_ulong;
    alias uint_fast32_t = c_ulong;
    alias uint_fast64_t = c_ulong;
    alias intptr_t = c_long;
    ion_error_code ion_decimal_scaleb(_ion_decimal*, const(_ion_decimal)*, const(_ion_decimal)*, decContext*) @nogc nothrow;
    alias uintptr_t = c_ulong;
    alias intmax_t = c_long;
    alias uintmax_t = c_ulong;
    ion_error_code ion_decimal_rotate(_ion_decimal*, const(_ion_decimal)*, const(_ion_decimal)*, decContext*) @nogc nothrow;
    ion_error_code ion_decimal_remainder_near(_ion_decimal*, const(_ion_decimal)*, const(_ion_decimal)*, decContext*) @nogc nothrow;
    ion_error_code ion_decimal_remainder(_ion_decimal*, const(_ion_decimal)*, const(_ion_decimal)*, decContext*) @nogc nothrow;
    ion_error_code ion_decimal_quantize(_ion_decimal*, const(_ion_decimal)*, const(_ion_decimal)*, decContext*) @nogc nothrow;
    ion_error_code ion_decimal_or(_ion_decimal*, const(_ion_decimal)*, const(_ion_decimal)*, decContext*) @nogc nothrow;
    ion_error_code ion_decimal_multiply(_ion_decimal*, const(_ion_decimal)*, const(_ion_decimal)*, decContext*) @nogc nothrow;
    ion_error_code ion_decimal_min_mag(_ion_decimal*, const(_ion_decimal)*, const(_ion_decimal)*, decContext*) @nogc nothrow;
    ion_error_code ion_decimal_min(_ion_decimal*, const(_ion_decimal)*, const(_ion_decimal)*, decContext*) @nogc nothrow;
    ion_error_code ion_decimal_max_mag(_ion_decimal*, const(_ion_decimal)*, const(_ion_decimal)*, decContext*) @nogc nothrow;
    ion_error_code ion_decimal_max(_ion_decimal*, const(_ion_decimal)*, const(_ion_decimal)*, decContext*) @nogc nothrow;
    ion_error_code ion_decimal_divide_integer(_ion_decimal*, const(_ion_decimal)*, const(_ion_decimal)*, decContext*) @nogc nothrow;
    ion_error_code ion_decimal_divide(_ion_decimal*, const(_ion_decimal)*, const(_ion_decimal)*, decContext*) @nogc nothrow;
    ion_error_code ion_decimal_and(_ion_decimal*, const(_ion_decimal)*, const(_ion_decimal)*, decContext*) @nogc nothrow;
    ion_error_code ion_decimal_add(_ion_decimal*, const(_ion_decimal)*, const(_ion_decimal)*, decContext*) @nogc nothrow;
    ion_error_code ion_decimal_fma(_ion_decimal*, const(_ion_decimal)*, const(_ion_decimal)*, const(_ion_decimal)*, decContext*) @nogc nothrow;
    ion_error_code ion_decimal_to_uint32(const(_ion_decimal)*, decContext*, uint*) @nogc nothrow;
    ion_error_code ion_decimal_to_int32(const(_ion_decimal)*, decContext*, int*) @nogc nothrow;
    ion_error_code ion_decimal_to_ion_int(const(_ion_decimal)*, decContext*, _ion_int*) @nogc nothrow;
    ion_error_code ion_decimal_from_ion_int(_ion_decimal*, decContext*, _ion_int*) @nogc nothrow;
    ion_error_code ion_decimal_from_number(_ion_decimal*, decNumber*) @nogc nothrow;
    ion_error_code ion_decimal_from_quad(_ion_decimal*, decQuad*) @nogc nothrow;
    ion_error_code ion_decimal_from_int32(_ion_decimal*, int) @nogc nothrow;
    ion_error_code ion_decimal_from_uint32(_ion_decimal*, uint) @nogc nothrow;
    ion_error_code ion_decimal_from_string(_ion_decimal*, const(char)*, decContext*) @nogc nothrow;
    ion_error_code ion_decimal_to_string(const(_ion_decimal)*, char*) @nogc nothrow;
    ion_error_code ion_decimal_free(_ion_decimal*) @nogc nothrow;
    ion_error_code ion_decimal_claim(_ion_decimal*) @nogc nothrow;
    ion_error_code ion_decimal_zero(_ion_decimal*) @nogc nothrow;
    enum _Anonymous_32
    {
        ION_DECIMAL_TYPE_UNKNOWN = 0,
        ION_DECIMAL_TYPE_QUAD = 1,
        ION_DECIMAL_TYPE_NUMBER = 2,
        ION_DECIMAL_TYPE_NUMBER_OWNED = 3,
    }
    enum ION_DECIMAL_TYPE_UNKNOWN = _Anonymous_32.ION_DECIMAL_TYPE_UNKNOWN;
    enum ION_DECIMAL_TYPE_QUAD = _Anonymous_32.ION_DECIMAL_TYPE_QUAD;
    enum ION_DECIMAL_TYPE_NUMBER = _Anonymous_32.ION_DECIMAL_TYPE_NUMBER;
    enum ION_DECIMAL_TYPE_NUMBER_OWNED = _Anonymous_32.ION_DECIMAL_TYPE_NUMBER_OWNED;
    alias ION_DECIMAL_TYPE = _Anonymous_32;
    void ion_debug_set_tracing(int) @nogc nothrow;
    int ion_debug_has_tracing() @nogc nothrow;
    alias off_t = c_long;
    alias ssize_t = c_long;
    extern __gshared int g_ion_debug_tracing;
    alias fpos_t = _G_fpos_t;
    alias ION_COLLECTION_CURSOR = _ion_collection_node*;
    struct _ion_collection_node
    {
        _ion_collection_node* _next;
        _ion_collection_node* _prev;
        ubyte[8] _data;
    }
    alias ION_COLLECTION_NODE = _ion_collection_node;
    ion_error_code ion_catalog_close(_ion_catalog*) @nogc nothrow;
    extern __gshared _IO_FILE* stdin;
    extern __gshared _IO_FILE* stdout;
    extern __gshared _IO_FILE* stderr;
    ion_error_code ion_catalog_release_symbol_table(_ion_catalog*, _ion_symbol_table*) @nogc nothrow;
    int remove(const(char)*) @nogc nothrow;
    int rename(const(char)*, const(char)*) @nogc nothrow;
    int renameat(int, const(char)*, int, const(char)*) @nogc nothrow;
    _IO_FILE* tmpfile() @nogc nothrow;
    char* tmpnam(char*) @nogc nothrow;
    char* tmpnam_r(char*) @nogc nothrow;
    char* tempnam(const(char)*, const(char)*) @nogc nothrow;
    int fclose(_IO_FILE*) @nogc nothrow;
    int fflush(_IO_FILE*) @nogc nothrow;
    int fflush_unlocked(_IO_FILE*) @nogc nothrow;
    _IO_FILE* fopen(const(char)*, const(char)*) @nogc nothrow;
    _IO_FILE* freopen(const(char)*, const(char)*, _IO_FILE*) @nogc nothrow;
    _IO_FILE* fdopen(int, const(char)*) @nogc nothrow;
    _IO_FILE* fmemopen(void*, c_ulong, const(char)*) @nogc nothrow;
    _IO_FILE* open_memstream(char**, c_ulong*) @nogc nothrow;
    void setbuf(_IO_FILE*, char*) @nogc nothrow;
    int setvbuf(_IO_FILE*, char*, int, c_ulong) @nogc nothrow;
    void setbuffer(_IO_FILE*, char*, c_ulong) @nogc nothrow;
    void setlinebuf(_IO_FILE*) @nogc nothrow;
    int fprintf(_IO_FILE*, const(char)*, ...) @nogc nothrow;
    int printf(const(char)*, ...) @nogc nothrow;
    int sprintf(char*, const(char)*, ...) @nogc nothrow;
    int vfprintf(_IO_FILE*, const(char)*, va_list*) @nogc nothrow;
    int vprintf(const(char)*, va_list*) @nogc nothrow;
    int vsprintf(char*, const(char)*, va_list*) @nogc nothrow;
    int snprintf(char*, c_ulong, const(char)*, ...) @nogc nothrow;
    int vsnprintf(char*, c_ulong, const(char)*, va_list*) @nogc nothrow;
    int vdprintf(int, const(char)*, va_list*) @nogc nothrow;
    int dprintf(int, const(char)*, ...) @nogc nothrow;
    int fscanf(_IO_FILE*, const(char)*, ...) @nogc nothrow;
    int scanf(const(char)*, ...) @nogc nothrow;
    int sscanf(const(char)*, const(char)*, ...) @nogc nothrow;
    int vfscanf(_IO_FILE*, const(char)*, va_list*) @nogc nothrow;
    int vscanf(const(char)*, va_list*) @nogc nothrow;
    int vsscanf(const(char)*, const(char)*, va_list*) @nogc nothrow;
    int fgetc(_IO_FILE*) @nogc nothrow;
    int getc(_IO_FILE*) @nogc nothrow;
    int getchar() @nogc nothrow;
    int getc_unlocked(_IO_FILE*) @nogc nothrow;
    int getchar_unlocked() @nogc nothrow;
    int fgetc_unlocked(_IO_FILE*) @nogc nothrow;
    int fputc(int, _IO_FILE*) @nogc nothrow;
    int putc(int, _IO_FILE*) @nogc nothrow;
    int putchar(int) @nogc nothrow;
    int fputc_unlocked(int, _IO_FILE*) @nogc nothrow;
    int putc_unlocked(int, _IO_FILE*) @nogc nothrow;
    int putchar_unlocked(int) @nogc nothrow;
    int getw(_IO_FILE*) @nogc nothrow;
    int putw(int, _IO_FILE*) @nogc nothrow;
    char* fgets(char*, int, _IO_FILE*) @nogc nothrow;
    c_long __getdelim(char**, c_ulong*, int, _IO_FILE*) @nogc nothrow;
    c_long getdelim(char**, c_ulong*, int, _IO_FILE*) @nogc nothrow;
    c_long getline(char**, c_ulong*, _IO_FILE*) @nogc nothrow;
    int fputs(const(char)*, _IO_FILE*) @nogc nothrow;
    int puts(const(char)*) @nogc nothrow;
    int ungetc(int, _IO_FILE*) @nogc nothrow;
    c_ulong fread(void*, c_ulong, c_ulong, _IO_FILE*) @nogc nothrow;
    c_ulong fwrite(const(void)*, c_ulong, c_ulong, _IO_FILE*) @nogc nothrow;
    c_ulong fread_unlocked(void*, c_ulong, c_ulong, _IO_FILE*) @nogc nothrow;
    c_ulong fwrite_unlocked(const(void)*, c_ulong, c_ulong, _IO_FILE*) @nogc nothrow;
    int fseek(_IO_FILE*, c_long, int) @nogc nothrow;
    c_long ftell(_IO_FILE*) @nogc nothrow;
    void rewind(_IO_FILE*) @nogc nothrow;
    int fseeko(_IO_FILE*, c_long, int) @nogc nothrow;
    c_long ftello(_IO_FILE*) @nogc nothrow;
    int fgetpos(_IO_FILE*, _G_fpos_t*) @nogc nothrow;
    int fsetpos(_IO_FILE*, const(_G_fpos_t)*) @nogc nothrow;
    void clearerr(_IO_FILE*) @nogc nothrow;
    int feof(_IO_FILE*) @nogc nothrow;
    int ferror(_IO_FILE*) @nogc nothrow;
    void clearerr_unlocked(_IO_FILE*) @nogc nothrow;
    int feof_unlocked(_IO_FILE*) @nogc nothrow;
    int ferror_unlocked(_IO_FILE*) @nogc nothrow;
    void perror(const(char)*) @nogc nothrow;
    int fileno(_IO_FILE*) @nogc nothrow;
    int fileno_unlocked(_IO_FILE*) @nogc nothrow;
    _IO_FILE* popen(const(char)*, const(char)*) @nogc nothrow;
    int pclose(_IO_FILE*) @nogc nothrow;
    char* ctermid(char*) @nogc nothrow;
    void flockfile(_IO_FILE*) @nogc nothrow;
    int ftrylockfile(_IO_FILE*) @nogc nothrow;
    void funlockfile(_IO_FILE*) @nogc nothrow;
    int __uflow(_IO_FILE*) @nogc nothrow;
    int __overflow(_IO_FILE*, int) @nogc nothrow;
    ion_error_code ion_catalog_find_best_match(_ion_catalog*, _ion_string*, c_long, _ion_symbol_table**) @nogc nothrow;
    ion_error_code ion_catalog_find_symbol_table(_ion_catalog*, _ion_string*, c_long, _ion_symbol_table**) @nogc nothrow;
    void* memcpy(void*, const(void)*, c_ulong) @nogc nothrow;
    void* memmove(void*, const(void)*, c_ulong) @nogc nothrow;
    void* memccpy(void*, const(void)*, int, c_ulong) @nogc nothrow;
    void* memset(void*, int, c_ulong) @nogc nothrow;
    int memcmp(const(void)*, const(void)*, c_ulong) @nogc nothrow;
    void* memchr(const(void)*, int, c_ulong) @nogc nothrow;
    char* strcpy(char*, const(char)*) @nogc nothrow;
    char* strncpy(char*, const(char)*, c_ulong) @nogc nothrow;
    char* strcat(char*, const(char)*) @nogc nothrow;
    char* strncat(char*, const(char)*, c_ulong) @nogc nothrow;
    int strcmp(const(char)*, const(char)*) @nogc nothrow;
    int strncmp(const(char)*, const(char)*, c_ulong) @nogc nothrow;
    int strcoll(const(char)*, const(char)*) @nogc nothrow;
    c_ulong strxfrm(char*, const(char)*, c_ulong) @nogc nothrow;
    int strcoll_l(const(char)*, const(char)*, __locale_struct*) @nogc nothrow;
    c_ulong strxfrm_l(char*, const(char)*, c_ulong, __locale_struct*) @nogc nothrow;
    char* strdup(const(char)*) @nogc nothrow;
    char* strndup(const(char)*, c_ulong) @nogc nothrow;
    char* strchr(const(char)*, int) @nogc nothrow;
    char* strrchr(const(char)*, int) @nogc nothrow;
    c_ulong strcspn(const(char)*, const(char)*) @nogc nothrow;
    c_ulong strspn(const(char)*, const(char)*) @nogc nothrow;
    char* strpbrk(const(char)*, const(char)*) @nogc nothrow;
    char* strstr(const(char)*, const(char)*) @nogc nothrow;
    char* strtok(char*, const(char)*) @nogc nothrow;
    char* __strtok_r(char*, const(char)*, char**) @nogc nothrow;
    char* strtok_r(char*, const(char)*, char**) @nogc nothrow;
    c_ulong strlen(const(char)*) @nogc nothrow;
    c_ulong strnlen(const(char)*, c_ulong) @nogc nothrow;
    char* strerror(int) @nogc nothrow;
    int strerror_r(int, char*, c_ulong) @nogc nothrow;
    char* strerror_l(int, __locale_struct*) @nogc nothrow;
    void explicit_bzero(void*, c_ulong) @nogc nothrow;
    char* strsep(char**, const(char)*) @nogc nothrow;
    char* strsignal(int) @nogc nothrow;
    char* __stpcpy(char*, const(char)*) @nogc nothrow;
    char* stpcpy(char*, const(char)*) @nogc nothrow;
    char* __stpncpy(char*, const(char)*, c_ulong) @nogc nothrow;
    char* stpncpy(char*, const(char)*, c_ulong) @nogc nothrow;
    ion_error_code ion_catalog_add_symbol_table(_ion_catalog*, _ion_symbol_table*) @nogc nothrow;
    ion_error_code ion_catalog_get_symbol_table_count(_ion_catalog*, int*) @nogc nothrow;
    int bcmp(const(void)*, const(void)*, c_ulong) @nogc nothrow;
    void bcopy(const(void)*, void*, c_ulong) @nogc nothrow;
    void bzero(void*, c_ulong) @nogc nothrow;
    char* index(const(char)*, int) @nogc nothrow;
    char* rindex(const(char)*, int) @nogc nothrow;
    int ffs(int) @nogc nothrow;
    int ffsl(c_long) @nogc nothrow;
    int ffsll(long) @nogc nothrow;
    int strcasecmp(const(char)*, const(char)*) @nogc nothrow;
    int strncasecmp(const(char)*, const(char)*, c_ulong) @nogc nothrow;
    int strcasecmp_l(const(char)*, const(char)*, __locale_struct*) @nogc nothrow;
    int strncasecmp_l(const(char)*, const(char)*, c_ulong, __locale_struct*) @nogc nothrow;
    ion_error_code ion_catalog_open_with_owner(_ion_catalog**, void*) @nogc nothrow;
    ion_error_code ion_catalog_open(_ion_catalog**) @nogc nothrow;
    const(char)* decQuadVersion() @nogc nothrow;
    uint decQuadSameQuantum(const(decQuad)*, const(decQuad)*) @nogc nothrow;
    uint decQuadRadix(const(decQuad)*) @nogc nothrow;
    uint decQuadIsZero(const(decQuad)*) @nogc nothrow;
    uint decQuadIsSubnormal(const(decQuad)*) @nogc nothrow;
    uint decQuadIsSigned(const(decQuad)*) @nogc nothrow;
    uint decQuadIsSignalling(const(decQuad)*) @nogc nothrow;
    uint decQuadIsSignaling(const(decQuad)*) @nogc nothrow;
    uint decQuadIsPositive(const(decQuad)*) @nogc nothrow;
    uint decQuadIsNormal(const(decQuad)*) @nogc nothrow;
    uint decQuadIsNegative(const(decQuad)*) @nogc nothrow;
    uint decQuadIsNaN(const(decQuad)*) @nogc nothrow;
    uint decQuadIsInfinite(const(decQuad)*) @nogc nothrow;
    uint decQuadIsLogical(const(decQuad)*) @nogc nothrow;
    uint decQuadIsInteger(const(decQuad)*) @nogc nothrow;
    uint decQuadIsFinite(const(decQuad)*) @nogc nothrow;
    uint decQuadIsCanonical(const(decQuad)*) @nogc nothrow;
    uint decQuadDigits(const(decQuad)*) @nogc nothrow;
    const(char)* decQuadClassString(const(decQuad)*) @nogc nothrow;
    decClass decQuadClass(const(decQuad)*) @nogc nothrow;
    decQuad* decQuadCopySign(decQuad*, const(decQuad)*, const(decQuad)*) @nogc nothrow;
    decQuad* decQuadCopyNegate(decQuad*, const(decQuad)*) @nogc nothrow;
    decQuad* decQuadCopyAbs(decQuad*, const(decQuad)*) @nogc nothrow;
    decQuad* decQuadCopy(decQuad*, const(decQuad)*) @nogc nothrow;
    decQuad* decQuadCanonical(decQuad*, const(decQuad)*) @nogc nothrow;
    decQuad* decQuadCompareTotalMag(decQuad*, const(decQuad)*, const(decQuad)*) @nogc nothrow;
    decQuad* decQuadCompareTotal(decQuad*, const(decQuad)*, const(decQuad)*) @nogc nothrow;
    decQuad* decQuadCompareSignal(decQuad*, const(decQuad)*, const(decQuad)*, decContext*) @nogc nothrow;
    decQuad* decQuadCompare(decQuad*, const(decQuad)*, const(decQuad)*, decContext*) @nogc nothrow;
    decQuad* decQuadXor(decQuad*, const(decQuad)*, const(decQuad)*, decContext*) @nogc nothrow;
    decQuad* decQuadToIntegralExact(decQuad*, const(decQuad)*, decContext*) @nogc nothrow;
    decQuad* decQuadToIntegralValue(decQuad*, const(decQuad)*, decContext*, rounding) @nogc nothrow;
    decQuad* decQuadSubtract(decQuad*, const(decQuad)*, const(decQuad)*, decContext*) @nogc nothrow;
    decQuad* decQuadShift(decQuad*, const(decQuad)*, const(decQuad)*, decContext*) @nogc nothrow;
    decQuad* decQuadScaleB(decQuad*, const(decQuad)*, const(decQuad)*, decContext*) @nogc nothrow;
    decQuad* decQuadRotate(decQuad*, const(decQuad)*, const(decQuad)*, decContext*) @nogc nothrow;
    decQuad* decQuadRemainderNear(decQuad*, const(decQuad)*, const(decQuad)*, decContext*) @nogc nothrow;
    decQuad* decQuadRemainder(decQuad*, const(decQuad)*, const(decQuad)*, decContext*) @nogc nothrow;
    decQuad* decQuadReduce(decQuad*, const(decQuad)*, decContext*) @nogc nothrow;
    decQuad* decQuadQuantize(decQuad*, const(decQuad)*, const(decQuad)*, decContext*) @nogc nothrow;
    decQuad* decQuadPlus(decQuad*, const(decQuad)*, decContext*) @nogc nothrow;
    decQuad* decQuadOr(decQuad*, const(decQuad)*, const(decQuad)*, decContext*) @nogc nothrow;
    decQuad* decQuadNextToward(decQuad*, const(decQuad)*, const(decQuad)*, decContext*) @nogc nothrow;
    alias greg_t = long;
    decQuad* decQuadNextPlus(decQuad*, const(decQuad)*, decContext*) @nogc nothrow;
    decQuad* decQuadNextMinus(decQuad*, const(decQuad)*, decContext*) @nogc nothrow;
    alias gregset_t = long[23];
    struct _libc_fpxreg
    {
        ushort[4] significand;
        ushort exponent;
        ushort[3] __glibc_reserved1;
    }
    struct _libc_xmmreg
    {
        uint[4] element;
    }
    struct _libc_fpstate
    {
        ushort cwd;
        ushort swd;
        ushort ftw;
        ushort fop;
        c_ulong rip;
        c_ulong rdp;
        uint mxcsr;
        uint mxcr_mask;
        _libc_fpxreg[8] _st;
        _libc_xmmreg[16] _xmm;
        uint[24] __glibc_reserved1;
    }
    alias fpregset_t = _libc_fpstate*;
    struct mcontext_t
    {
        long[23] gregs;
        _libc_fpstate* fpregs;
        ulong[8] __reserved1;
    }
    struct ucontext_t
    {
        c_ulong uc_flags;
        ucontext_t* uc_link;
        stack_t uc_stack;
        mcontext_t uc_mcontext;
        __sigset_t uc_sigmask;
        _libc_fpstate __fpregs_mem;
        ulong[4] __ssp;
    }
    decQuad* decQuadMultiply(decQuad*, const(decQuad)*, const(decQuad)*, decContext*) @nogc nothrow;
    decQuad* decQuadMinus(decQuad*, const(decQuad)*, decContext*) @nogc nothrow;
    decQuad* decQuadMinMag(decQuad*, const(decQuad)*, const(decQuad)*, decContext*) @nogc nothrow;
    decQuad* decQuadMin(decQuad*, const(decQuad)*, const(decQuad)*, decContext*) @nogc nothrow;
    c_long clock() @nogc nothrow;
    c_long time(c_long*) @nogc nothrow;
    double difftime(c_long, c_long) @nogc nothrow;
    c_long mktime(tm*) @nogc nothrow;
    c_ulong strftime(char*, c_ulong, const(char)*, const(tm)*) @nogc nothrow;
    c_ulong strftime_l(char*, c_ulong, const(char)*, const(tm)*, __locale_struct*) @nogc nothrow;
    tm* gmtime(const(c_long)*) @nogc nothrow;
    tm* localtime(const(c_long)*) @nogc nothrow;
    tm* gmtime_r(const(c_long)*, tm*) @nogc nothrow;
    tm* localtime_r(const(c_long)*, tm*) @nogc nothrow;
    char* asctime(const(tm)*) @nogc nothrow;
    char* ctime(const(c_long)*) @nogc nothrow;
    char* asctime_r(const(tm)*, char*) @nogc nothrow;
    char* ctime_r(const(c_long)*, char*) @nogc nothrow;
    extern __gshared char*[2] __tzname;
    extern __gshared int __daylight;
    extern __gshared c_long __timezone;
    extern __gshared char*[2] tzname;
    void tzset() @nogc nothrow;
    extern __gshared int daylight;
    extern __gshared c_long timezone;
    decQuad* decQuadMaxMag(decQuad*, const(decQuad)*, const(decQuad)*, decContext*) @nogc nothrow;
    c_long timegm(tm*) @nogc nothrow;
    c_long timelocal(tm*) @nogc nothrow;
    int dysize(int) @nogc nothrow;
    int nanosleep(const(timespec)*, timespec*) @nogc nothrow;
    int clock_getres(int, timespec*) @nogc nothrow;
    int clock_gettime(int, timespec*) @nogc nothrow;
    int clock_settime(int, const(timespec)*) @nogc nothrow;
    int clock_nanosleep(int, int, const(timespec)*, timespec*) @nogc nothrow;
    int clock_getcpuclockid(int, int*) @nogc nothrow;
    int timer_create(int, sigevent*, void**) @nogc nothrow;
    int timer_delete(void*) @nogc nothrow;
    int timer_settime(void*, int, const(itimerspec)*, itimerspec*) @nogc nothrow;
    int timer_gettime(void*, itimerspec*) @nogc nothrow;
    int timer_getoverrun(void*) @nogc nothrow;
    int timespec_get(timespec*, int) @nogc nothrow;
    decQuad* decQuadMax(decQuad*, const(decQuad)*, const(decQuad)*, decContext*) @nogc nothrow;
    decQuad* decQuadLogB(decQuad*, const(decQuad)*, decContext*) @nogc nothrow;
    decQuad* decQuadInvert(decQuad*, const(decQuad)*, decContext*) @nogc nothrow;
    decQuad* decQuadFMA(decQuad*, const(decQuad)*, const(decQuad)*, const(decQuad)*, decContext*) @nogc nothrow;
    decQuad* decQuadDivideInteger(decQuad*, const(decQuad)*, const(decQuad)*, decContext*) @nogc nothrow;
    decQuad* decQuadDivide(decQuad*, const(decQuad)*, const(decQuad)*, decContext*) @nogc nothrow;
    decQuad* decQuadAnd(decQuad*, const(decQuad)*, const(decQuad)*, decContext*) @nogc nothrow;
    decQuad* decQuadAdd(decQuad*, const(decQuad)*, const(decQuad)*, decContext*) @nogc nothrow;
    decQuad* decQuadAbs(decQuad*, const(decQuad)*, decContext*) @nogc nothrow;
    alias size_t = c_ulong;
    decQuad* decQuadZero(decQuad*) @nogc nothrow;
    uint decQuadToUInt32Exact(const(decQuad)*, decContext*, rounding) @nogc nothrow;
    uint decQuadToUInt32(const(decQuad)*, decContext*, rounding) @nogc nothrow;
    char* decQuadToString(const(decQuad)*, char*) @nogc nothrow;
    int decQuadToPacked(const(decQuad)*, int*, ubyte*) @nogc nothrow;
    int decQuadToInt32Exact(const(decQuad)*, decContext*, rounding) @nogc nothrow;
    int decQuadToInt32(const(decQuad)*, decContext*, rounding) @nogc nothrow;
    char* decQuadToEngString(const(decQuad)*, char*) @nogc nothrow;
    int decQuadToBCD(const(decQuad)*, int*, ubyte*) @nogc nothrow;
    void decQuadShow(const(decQuad)*, const(char)*) @nogc nothrow;
    enum rounding
    {
        DEC_ROUND_CEILING = 0,
        DEC_ROUND_UP = 1,
        DEC_ROUND_HALF_UP = 2,
        DEC_ROUND_HALF_EVEN = 3,
        DEC_ROUND_HALF_DOWN = 4,
        DEC_ROUND_DOWN = 5,
        DEC_ROUND_FLOOR = 6,
        DEC_ROUND_05UP = 7,
        DEC_ROUND_MAX = 8,
    }
    enum DEC_ROUND_CEILING = rounding.DEC_ROUND_CEILING;
    enum DEC_ROUND_UP = rounding.DEC_ROUND_UP;
    enum DEC_ROUND_HALF_UP = rounding.DEC_ROUND_HALF_UP;
    enum DEC_ROUND_HALF_EVEN = rounding.DEC_ROUND_HALF_EVEN;
    enum DEC_ROUND_HALF_DOWN = rounding.DEC_ROUND_HALF_DOWN;
    enum DEC_ROUND_DOWN = rounding.DEC_ROUND_DOWN;
    enum DEC_ROUND_FLOOR = rounding.DEC_ROUND_FLOOR;
    enum DEC_ROUND_05UP = rounding.DEC_ROUND_05UP;
    enum DEC_ROUND_MAX = rounding.DEC_ROUND_MAX;
    decQuad* decQuadSetExponent(decQuad*, decContext*, int) @nogc nothrow;
    struct decContext
    {
        int digits;
        int emax;
        int emin;
        rounding round;
        uint traps;
        uint status;
        ubyte clamp;
    }
    decQuad* decQuadSetCoefficient(decQuad*, const(ubyte)*, int) @nogc nothrow;
    int decQuadGetExponent(const(decQuad)*) @nogc nothrow;
    int decQuadGetCoefficient(const(decQuad)*, ubyte*) @nogc nothrow;
    decQuad* decQuadFromUInt32(decQuad*, uint) @nogc nothrow;
    decQuad* decQuadFromString(decQuad*, const(char)*, decContext*) @nogc nothrow;
    decQuad* decQuadFromPackedChecked(decQuad*, int, const(ubyte)*) @nogc nothrow;
    decQuad* decQuadFromPacked(decQuad*, int, const(ubyte)*) @nogc nothrow;
    enum decClass
    {
        DEC_CLASS_SNAN = 0,
        DEC_CLASS_QNAN = 1,
        DEC_CLASS_NEG_INF = 2,
        DEC_CLASS_NEG_NORMAL = 3,
        DEC_CLASS_NEG_SUBNORMAL = 4,
        DEC_CLASS_NEG_ZERO = 5,
        DEC_CLASS_POS_ZERO = 6,
        DEC_CLASS_POS_SUBNORMAL = 7,
        DEC_CLASS_POS_NORMAL = 8,
        DEC_CLASS_POS_INF = 9,
    }
    enum DEC_CLASS_SNAN = decClass.DEC_CLASS_SNAN;
    enum DEC_CLASS_QNAN = decClass.DEC_CLASS_QNAN;
    enum DEC_CLASS_NEG_INF = decClass.DEC_CLASS_NEG_INF;
    enum DEC_CLASS_NEG_NORMAL = decClass.DEC_CLASS_NEG_NORMAL;
    enum DEC_CLASS_NEG_SUBNORMAL = decClass.DEC_CLASS_NEG_SUBNORMAL;
    enum DEC_CLASS_NEG_ZERO = decClass.DEC_CLASS_NEG_ZERO;
    enum DEC_CLASS_POS_ZERO = decClass.DEC_CLASS_POS_ZERO;
    enum DEC_CLASS_POS_SUBNORMAL = decClass.DEC_CLASS_POS_SUBNORMAL;
    enum DEC_CLASS_POS_NORMAL = decClass.DEC_CLASS_POS_NORMAL;
    enum DEC_CLASS_POS_INF = decClass.DEC_CLASS_POS_INF;
    decQuad* decQuadFromInt32(decQuad*, int) @nogc nothrow;
    decQuad* decQuadFromBCD(decQuad*, int, const(ubyte)*, int) @nogc nothrow;
    union decQuad
    {
        ubyte[16] bytes;
        ushort[8] shorts;
        uint[4] words;
    }
    int decNumberIsSubnormal(const(decNumber)*, decContext*) @nogc nothrow;
    int decNumberIsNormal(const(decNumber)*, decContext*) @nogc nothrow;
    decNumber* decNumberZero(decNumber*) @nogc nothrow;
    const(char)* decNumberVersion() @nogc nothrow;
    decNumber* decNumberTrim(decNumber*) @nogc nothrow;
    decNumber* decNumberNextToward(decNumber*, const(decNumber)*, const(decNumber)*, decContext*) @nogc nothrow;
    decNumber* decNumberNextPlus(decNumber*, const(decNumber)*, decContext*) @nogc nothrow;
    decNumber* decNumberNextMinus(decNumber*, const(decNumber)*, decContext*) @nogc nothrow;
    decNumber* decNumberCopySign(decNumber*, const(decNumber)*, const(decNumber)*) @nogc nothrow;
    decNumber* decNumberCopyNegate(decNumber*, const(decNumber)*) @nogc nothrow;
    decNumber* decNumberCopyAbs(decNumber*, const(decNumber)*) @nogc nothrow;
    decNumber* decNumberCopy(decNumber*, const(decNumber)*) @nogc nothrow;
    const(char)* decNumberClassToString(decClass) @nogc nothrow;
    decClass decNumberClass(const(decNumber)*, decContext*) @nogc nothrow;
    decNumber* decNumberXor(decNumber*, const(decNumber)*, const(decNumber)*, decContext*) @nogc nothrow;
    decNumber* decNumberToIntegralValue(decNumber*, const(decNumber)*, decContext*) @nogc nothrow;
    decNumber* decNumberToIntegralExact(decNumber*, const(decNumber)*, decContext*) @nogc nothrow;
    decNumber* decNumberSubtract(decNumber*, const(decNumber)*, const(decNumber)*, decContext*) @nogc nothrow;
    decNumber* decNumberSquareRoot(decNumber*, const(decNumber)*, decContext*) @nogc nothrow;
    decNumber* decNumberShift(decNumber*, const(decNumber)*, const(decNumber)*, decContext*) @nogc nothrow;
    decNumber* decNumberScaleB(decNumber*, const(decNumber)*, const(decNumber)*, decContext*) @nogc nothrow;
    decNumber* decNumberSameQuantum(decNumber*, const(decNumber)*, const(decNumber)*) @nogc nothrow;
    decNumber* decNumberRotate(decNumber*, const(decNumber)*, const(decNumber)*, decContext*) @nogc nothrow;
    decNumber* decNumberRescale(decNumber*, const(decNumber)*, const(decNumber)*, decContext*) @nogc nothrow;
    decNumber* decNumberRemainderNear(decNumber*, const(decNumber)*, const(decNumber)*, decContext*) @nogc nothrow;
    decNumber* decNumberRemainder(decNumber*, const(decNumber)*, const(decNumber)*, decContext*) @nogc nothrow;
    decNumber* decNumberReduce(decNumber*, const(decNumber)*, decContext*) @nogc nothrow;
    decNumber* decNumberQuantize(decNumber*, const(decNumber)*, const(decNumber)*, decContext*) @nogc nothrow;
    decNumber* decNumberPower(decNumber*, const(decNumber)*, const(decNumber)*, decContext*) @nogc nothrow;
    decNumber* decNumberPlus(decNumber*, const(decNumber)*, decContext*) @nogc nothrow;
    decNumber* decNumberOr(decNumber*, const(decNumber)*, const(decNumber)*, decContext*) @nogc nothrow;
    decNumber* decNumberNormalize(decNumber*, const(decNumber)*, decContext*) @nogc nothrow;
    decNumber* decNumberMultiply(decNumber*, const(decNumber)*, const(decNumber)*, decContext*) @nogc nothrow;
    decNumber* decNumberMinus(decNumber*, const(decNumber)*, decContext*) @nogc nothrow;
    decNumber* decNumberMinMag(decNumber*, const(decNumber)*, const(decNumber)*, decContext*) @nogc nothrow;
    decNumber* decNumberMin(decNumber*, const(decNumber)*, const(decNumber)*, decContext*) @nogc nothrow;
    decNumber* decNumberMaxMag(decNumber*, const(decNumber)*, const(decNumber)*, decContext*) @nogc nothrow;
    decNumber* decNumberMax(decNumber*, const(decNumber)*, const(decNumber)*, decContext*) @nogc nothrow;
    decNumber* decNumberLog10(decNumber*, const(decNumber)*, decContext*) @nogc nothrow;
    decNumber* decNumberLogB(decNumber*, const(decNumber)*, decContext*) @nogc nothrow;
    decNumber* decNumberLn(decNumber*, const(decNumber)*, decContext*) @nogc nothrow;
    decNumber* decNumberInvert(decNumber*, const(decNumber)*, decContext*) @nogc nothrow;
    decNumber* decNumberFMA(decNumber*, const(decNumber)*, const(decNumber)*, const(decNumber)*, decContext*) @nogc nothrow;
    decNumber* decNumberExp(decNumber*, const(decNumber)*, decContext*) @nogc nothrow;
    decNumber* decNumberDivideInteger(decNumber*, const(decNumber)*, const(decNumber)*, decContext*) @nogc nothrow;
    decNumber* decNumberDivide(decNumber*, const(decNumber)*, const(decNumber)*, decContext*) @nogc nothrow;
    decNumber* decNumberCompareTotalMag(decNumber*, const(decNumber)*, const(decNumber)*, decContext*) @nogc nothrow;
    decNumber* decNumberCompareTotal(decNumber*, const(decNumber)*, const(decNumber)*, decContext*) @nogc nothrow;
    decNumber* decNumberCompareSignal(decNumber*, const(decNumber)*, const(decNumber)*, decContext*) @nogc nothrow;
    decNumber* decNumberCompare(decNumber*, const(decNumber)*, const(decNumber)*, decContext*) @nogc nothrow;
    decNumber* decNumberAnd(decNumber*, const(decNumber)*, const(decNumber)*, decContext*) @nogc nothrow;
    decNumber* decNumberAdd(decNumber*, const(decNumber)*, const(decNumber)*, decContext*) @nogc nothrow;
    decContext* decContextClearStatus(decContext*, uint) @nogc nothrow;
    decContext* decContextDefault(decContext*, int) @nogc nothrow;
    rounding decContextGetRounding(decContext*) @nogc nothrow;
    uint decContextGetStatus(decContext*) @nogc nothrow;
    decContext* decContextRestoreStatus(decContext*, uint, uint) @nogc nothrow;
    uint decContextSaveStatus(decContext*, uint) @nogc nothrow;
    decContext* decContextSetRounding(decContext*, rounding) @nogc nothrow;
    decContext* decContextSetStatus(decContext*, uint) @nogc nothrow;
    decContext* decContextSetStatusFromString(decContext*, const(char)*) @nogc nothrow;
    decContext* decContextSetStatusFromStringQuiet(decContext*, const(char)*) @nogc nothrow;
    decContext* decContextSetStatusQuiet(decContext*, uint) @nogc nothrow;
    const(char)* decContextStatusToString(const(decContext)*) @nogc nothrow;
    int decContextTestEndian(ubyte) @nogc nothrow;
    uint decContextTestSavedStatus(uint, uint) @nogc nothrow;
    uint decContextTestStatus(decContext*, uint) @nogc nothrow;
    decContext* decContextZeroStatus(decContext*) @nogc nothrow;
    decNumber* decNumberAbs(decNumber*, const(decNumber)*, decContext*) @nogc nothrow;
    decNumber* decNumberSetBCD(decNumber*, const(ubyte)*, uint) @nogc nothrow;
    ubyte* decNumberGetBCD(const(decNumber)*, ubyte*) @nogc nothrow;
    int decNumberToInt32(const(decNumber)*, decContext*) @nogc nothrow;
    uint decNumberToUInt32(const(decNumber)*, decContext*) @nogc nothrow;
    char* decNumberToEngString(const(decNumber)*, char*) @nogc nothrow;
    char* decNumberToString(const(decNumber)*, char*) @nogc nothrow;
    decNumber* decNumberFromString(decNumber*, const(char)*, decContext*) @nogc nothrow;
    decNumber* decNumberFromUInt32(decNumber*, uint) @nogc nothrow;
    decNumber* decNumberFromInt32(decNumber*, int) @nogc nothrow;
    struct decNumber
    {
        int digits;
        int exponent;
        ubyte bits;
        ushort[12] lsu;
    }
    static if(!is(typeof(DECDPUN))) {
        enum DECDPUN = 3;
    }






    static if(!is(typeof(DECSNAN))) {
        enum DECSNAN = 0x10;
    }




    static if(!is(typeof(DECNAN))) {
        enum DECNAN = 0x20;
    }




    static if(!is(typeof(DECINF))) {
        enum DECINF = 0x40;
    }




    static if(!is(typeof(DECNEG))) {
        enum DECNEG = 0x80;
    }




    static if(!is(typeof(DECAUTHOR))) {
        enum DECAUTHOR = "Mike Cowlishaw";
    }




    static if(!is(typeof(DECFULLNAME))) {
        enum DECFULLNAME = "Decimal Number Module";
    }




    static if(!is(typeof(DECNAME))) {
        enum DECNAME = "decNumber";
    }
    static if(!is(typeof(DEC_INIT_DECIMAL128))) {
        enum DEC_INIT_DECIMAL128 = 128;
    }




    static if(!is(typeof(DEC_INIT_DECIMAL64))) {
        enum DEC_INIT_DECIMAL64 = 64;
    }




    static if(!is(typeof(DEC_INIT_DECIMAL32))) {
        enum DEC_INIT_DECIMAL32 = 32;
    }




    static if(!is(typeof(DEC_INIT_BASE))) {
        enum DEC_INIT_BASE = 0;
    }




    static if(!is(typeof(DEC_Condition_Length))) {
        enum DEC_Condition_Length = 21;
    }




    static if(!is(typeof(DEC_Condition_MU))) {
        enum DEC_Condition_MU = "Multiple status";
    }




    static if(!is(typeof(DEC_Condition_ZE))) {
        enum DEC_Condition_ZE = "No status";
    }




    static if(!is(typeof(DEC_Condition_UN))) {
        enum DEC_Condition_UN = "Underflow";
    }




    static if(!is(typeof(DEC_Condition_SU))) {
        enum DEC_Condition_SU = "Subnormal";
    }




    static if(!is(typeof(DEC_Condition_RO))) {
        enum DEC_Condition_RO = "Rounded";
    }




    static if(!is(typeof(DEC_Condition_PA))) {
        enum DEC_Condition_PA = "Clamped";
    }




    static if(!is(typeof(DEC_Condition_OV))) {
        enum DEC_Condition_OV = "Overflow";
    }




    static if(!is(typeof(DEC_Condition_IO))) {
        enum DEC_Condition_IO = "Invalid operation";
    }




    static if(!is(typeof(DEC_Condition_IC))) {
        enum DEC_Condition_IC = "Invalid context";
    }




    static if(!is(typeof(DEC_Condition_IS))) {
        enum DEC_Condition_IS = "Insufficient storage";
    }




    static if(!is(typeof(DEC_Condition_IE))) {
        enum DEC_Condition_IE = "Inexact";
    }




    static if(!is(typeof(DEC_Condition_DU))) {
        enum DEC_Condition_DU = "Division undefined";
    }




    static if(!is(typeof(DEC_Condition_DI))) {
        enum DEC_Condition_DI = "Division impossible";
    }




    static if(!is(typeof(DEC_Condition_DZ))) {
        enum DEC_Condition_DZ = "Division by zero";
    }




    static if(!is(typeof(DEC_Condition_CS))) {
        enum DEC_Condition_CS = "Conversion syntax";
    }
    static if(!is(typeof(DEC_Underflow))) {
        enum DEC_Underflow = 0x00002000;
    }




    static if(!is(typeof(DEC_Subnormal))) {
        enum DEC_Subnormal = 0x00001000;
    }




    static if(!is(typeof(DEC_Rounded))) {
        enum DEC_Rounded = 0x00000800;
    }




    static if(!is(typeof(DEC_Clamped))) {
        enum DEC_Clamped = 0x00000400;
    }




    static if(!is(typeof(DEC_Overflow))) {
        enum DEC_Overflow = 0x00000200;
    }




    static if(!is(typeof(DEC_Invalid_operation))) {
        enum DEC_Invalid_operation = 0x00000080;
    }




    static if(!is(typeof(DEC_Invalid_context))) {
        enum DEC_Invalid_context = 0x00000040;
    }




    static if(!is(typeof(DEC_Inexact))) {
        enum DEC_Inexact = 0x00000020;
    }




    static if(!is(typeof(DEC_Insufficient_storage))) {
        enum DEC_Insufficient_storage = 0x00000010;
    }




    static if(!is(typeof(DEC_Division_undefined))) {
        enum DEC_Division_undefined = 0x00000008;
    }




    static if(!is(typeof(DEC_Division_impossible))) {
        enum DEC_Division_impossible = 0x00000004;
    }




    static if(!is(typeof(DEC_Division_by_zero))) {
        enum DEC_Division_by_zero = 0x00000002;
    }




    static if(!is(typeof(DEC_Conversion_syntax))) {
        enum DEC_Conversion_syntax = 0x00000001;
    }




    static if(!is(typeof(DEC_ClassString_UN))) {
        enum DEC_ClassString_UN = "Invalid";
    }




    static if(!is(typeof(DEC_ClassString_PI))) {
        enum DEC_ClassString_PI = "+Infinity";
    }




    static if(!is(typeof(DEC_ClassString_PN))) {
        enum DEC_ClassString_PN = "+Normal";
    }
    static if(!is(typeof(DECQUADNAME))) {
        enum DECQUADNAME = "decimalQuad";
    }




    static if(!is(typeof(DECQUADTITLE))) {
        enum DECQUADTITLE = "Decimal 128-bit datum";
    }




    static if(!is(typeof(DECQUADAUTHOR))) {
        enum DECQUADAUTHOR = "Mike Cowlishaw";
    }




    static if(!is(typeof(DECQUAD_Bytes))) {
        enum DECQUAD_Bytes = 16;
    }




    static if(!is(typeof(DECQUAD_Pmax))) {
        enum DECQUAD_Pmax = 34;
    }






    static if(!is(typeof(DECQUAD_Emax))) {
        enum DECQUAD_Emax = 6144;
    }




    static if(!is(typeof(DECQUAD_EmaxD))) {
        enum DECQUAD_EmaxD = 4;
    }




    static if(!is(typeof(DECQUAD_Bias))) {
        enum DECQUAD_Bias = 6176;
    }




    static if(!is(typeof(DECQUAD_String))) {
        enum DECQUAD_String = 43;
    }




    static if(!is(typeof(DECQUAD_EconL))) {
        enum DECQUAD_EconL = 12;
    }




    static if(!is(typeof(DECQUAD_Declets))) {
        enum DECQUAD_Declets = 11;
    }






    static if(!is(typeof(DEC_ClassString_PS))) {
        enum DEC_ClassString_PS = "+Subnormal";
    }




    static if(!is(typeof(DEC_ClassString_PZ))) {
        enum DEC_ClassString_PZ = "+Zero";
    }




    static if(!is(typeof(DEC_ClassString_NZ))) {
        enum DEC_ClassString_NZ = "-Zero";
    }




    static if(!is(typeof(DEC_ClassString_NS))) {
        enum DEC_ClassString_NS = "-Subnormal";
    }




    static if(!is(typeof(DEC_ClassString_NN))) {
        enum DEC_ClassString_NN = "-Normal";
    }




    static if(!is(typeof(DEC_ClassString_NI))) {
        enum DEC_ClassString_NI = "-Infinity";
    }




    static if(!is(typeof(DECFLOAT_Sign))) {
        enum DECFLOAT_Sign = 0x80000000;
    }




    static if(!is(typeof(DECFLOAT_NaN))) {
        enum DECFLOAT_NaN = 0x7c000000;
    }




    static if(!is(typeof(DECFLOAT_qNaN))) {
        enum DECFLOAT_qNaN = 0x7c000000;
    }




    static if(!is(typeof(DECFLOAT_sNaN))) {
        enum DECFLOAT_sNaN = 0x7e000000;
    }




    static if(!is(typeof(DECFLOAT_Inf))) {
        enum DECFLOAT_Inf = 0x78000000;
    }




    static if(!is(typeof(DECFLOAT_MinSp))) {
        enum DECFLOAT_MinSp = 0x78000000;
    }




    static if(!is(typeof(DECPPLUSALT))) {
        enum DECPPLUSALT = 0x0A;
    }




    static if(!is(typeof(DECPMINUSALT))) {
        enum DECPMINUSALT = 0x0B;
    }




    static if(!is(typeof(DECPPLUS))) {
        enum DECPPLUS = 0x0C;
    }




    static if(!is(typeof(DECPMINUS))) {
        enum DECPMINUS = 0x0D;
    }




    static if(!is(typeof(DECPPLUSALT2))) {
        enum DECPPLUSALT2 = 0x0E;
    }




    static if(!is(typeof(DECPUNSIGNED))) {
        enum DECPUNSIGNED = 0x0F;
    }




    static if(!is(typeof(DEC_ClassString_QN))) {
        enum DEC_ClassString_QN = "NaN";
    }




    static if(!is(typeof(DEC_ClassString_SN))) {
        enum DEC_ClassString_SN = "sNaN";
    }




    static if(!is(typeof(DEC_MAX_MATH))) {
        enum DEC_MAX_MATH = 999999;
    }






    static if(!is(typeof(DEC_MAX_EMIN))) {
        enum DEC_MAX_EMIN = 0;
    }




    static if(!is(typeof(DEC_MIN_EMAX))) {
        enum DEC_MIN_EMAX = 0;
    }




    static if(!is(typeof(DEC_MAX_EMAX))) {
        enum DEC_MAX_EMAX = 999999999;
    }




    static if(!is(typeof(DEC_MIN_DIGITS))) {
        enum DEC_MIN_DIGITS = 1;
    }




    static if(!is(typeof(DEC_MAX_DIGITS))) {
        enum DEC_MAX_DIGITS = 999999999;
    }






    static if(!is(typeof(DECSUBSET))) {
        enum DECSUBSET = 0;
    }




    static if(!is(typeof(DECEXTFLAG))) {
        enum DECEXTFLAG = 1;
    }




    static if(!is(typeof(DECCAUTHOR))) {
        enum DECCAUTHOR = "Mike Cowlishaw";
    }




    static if(!is(typeof(DECCFULLNAME))) {
        enum DECCFULLNAME = "Decimal Context Descriptor";
    }




    static if(!is(typeof(DECCNAME))) {
        enum DECCNAME = "decContext";
    }
    static if(!is(typeof(__GNUC_VA_LIST))) {
        enum __GNUC_VA_LIST = 1;
    }
    static if(!is(typeof(TIME_UTC))) {
        enum TIME_UTC = 1;
    }
    static if(!is(typeof(_TIME_H))) {
        enum _TIME_H = 1;
    }






    static if(!is(typeof(__NGREG))) {
        enum __NGREG = 23;
    }






    static if(!is(typeof(_SYS_UCONTEXT_H))) {
        enum _SYS_UCONTEXT_H = 1;
    }




    static if(!is(typeof(__HAVE_GENERIC_SELECTION))) {
        enum __HAVE_GENERIC_SELECTION = 1;
    }
    static if(!is(typeof(__glibc_c99_flexarr_available))) {
        enum __glibc_c99_flexarr_available = 1;
    }
    static if(!is(typeof(_SYS_CDEFS_H))) {
        enum _SYS_CDEFS_H = 1;
    }




    static if(!is(typeof(_STRINGS_H))) {
        enum _STRINGS_H = 1;
    }






    static if(!is(typeof(_STRING_H))) {
        enum _STRING_H = 1;
    }
    static if(!is(typeof(P_tmpdir))) {
        enum P_tmpdir = "/tmp";
    }




    static if(!is(typeof(SEEK_END))) {
        enum SEEK_END = 2;
    }






    static if(!is(typeof(SEEK_CUR))) {
        enum SEEK_CUR = 1;
    }




    static if(!is(typeof(SEEK_SET))) {
        enum SEEK_SET = 0;
    }






    static if(!is(typeof(BUFSIZ))) {
        enum BUFSIZ = 8192;
    }






    static if(!is(typeof(_IONBF))) {
        enum _IONBF = 2;
    }
    static if(!is(typeof(_IOLBF))) {
        enum _IOLBF = 1;
    }




    static if(!is(typeof(_IOFBF))) {
        enum _IOFBF = 0;
    }




    static if(!is(typeof(ION_ERROR_MESSAGE_MAX_LENGTH))) {
        enum ION_ERROR_MESSAGE_MAX_LENGTH = 1024;
    }
    static if(!is(typeof(ION_TIMESTAMP_STRING_LENGTH))) {
        enum ION_TIMESTAMP_STRING_LENGTH = 55;
    }




    static if(!is(typeof(ION_VERSION_MARKER_LENGTH))) {
        enum ION_VERSION_MARKER_LENGTH = 4;
    }
    static if(!is(typeof(_STDIO_H))) {
        enum _STDIO_H = 1;
    }
    static if(!is(typeof(_STDINT_H))) {
        enum _STDINT_H = 1;
    }




    static if(!is(typeof(_STDC_PREDEF_H))) {
        enum _STDC_PREDEF_H = 1;
    }
    static if(!is(typeof(__GLIBC_MINOR__))) {
        enum __GLIBC_MINOR__ = 31;
    }




    static if(!is(typeof(__GLIBC__))) {
        enum __GLIBC__ = 2;
    }




    static if(!is(typeof(__GNU_LIBRARY__))) {
        enum __GNU_LIBRARY__ = 6;
    }




    static if(!is(typeof(__GLIBC_USE_DEPRECATED_SCANF))) {
        enum __GLIBC_USE_DEPRECATED_SCANF = 0;
    }




    static if(!is(typeof(__GLIBC_USE_DEPRECATED_GETS))) {
        enum __GLIBC_USE_DEPRECATED_GETS = 0;
    }




    static if(!is(typeof(__USE_FORTIFY_LEVEL))) {
        enum __USE_FORTIFY_LEVEL = 0;
    }




    static if(!is(typeof(__USE_ATFILE))) {
        enum __USE_ATFILE = 1;
    }




    static if(!is(typeof(__USE_MISC))) {
        enum __USE_MISC = 1;
    }




    static if(!is(typeof(_ATFILE_SOURCE))) {
        enum _ATFILE_SOURCE = 1;
    }




    static if(!is(typeof(__USE_XOPEN2K8))) {
        enum __USE_XOPEN2K8 = 1;
    }




    static if(!is(typeof(__USE_ISOC99))) {
        enum __USE_ISOC99 = 1;
    }




    static if(!is(typeof(__USE_ISOC95))) {
        enum __USE_ISOC95 = 1;
    }




    static if(!is(typeof(__USE_XOPEN2K))) {
        enum __USE_XOPEN2K = 1;
    }




    static if(!is(typeof(__USE_POSIX199506))) {
        enum __USE_POSIX199506 = 1;
    }




    static if(!is(typeof(__USE_POSIX199309))) {
        enum __USE_POSIX199309 = 1;
    }




    static if(!is(typeof(__USE_POSIX2))) {
        enum __USE_POSIX2 = 1;
    }




    static if(!is(typeof(__USE_POSIX))) {
        enum __USE_POSIX = 1;
    }




    static if(!is(typeof(_POSIX_C_SOURCE))) {
        enum _POSIX_C_SOURCE = 200809L;
    }




    static if(!is(typeof(_POSIX_SOURCE))) {
        enum _POSIX_SOURCE = 1;
    }




    static if(!is(typeof(__USE_POSIX_IMPLICITLY))) {
        enum __USE_POSIX_IMPLICITLY = 1;
    }




    static if(!is(typeof(__USE_ISOC11))) {
        enum __USE_ISOC11 = 1;
    }




    static if(!is(typeof(__GLIBC_USE_ISOC2X))) {
        enum __GLIBC_USE_ISOC2X = 0;
    }




    static if(!is(typeof(_DEFAULT_SOURCE))) {
        enum _DEFAULT_SOURCE = 1;
    }
    static if(!is(typeof(_FEATURES_H))) {
        enum _FEATURES_H = 1;
    }




    static if(!is(typeof(__SYSCALL_WORDSIZE))) {
        enum __SYSCALL_WORDSIZE = 64;
    }




    static if(!is(typeof(__WORDSIZE_TIME64_COMPAT32))) {
        enum __WORDSIZE_TIME64_COMPAT32 = 1;
    }




    static if(!is(typeof(__WORDSIZE))) {
        enum __WORDSIZE = 64;
    }
    static if(!is(typeof(_BITS_WCHAR_H))) {
        enum _BITS_WCHAR_H = 1;
    }




    static if(!is(typeof(__FD_SETSIZE))) {
        enum __FD_SETSIZE = 1024;
    }




    static if(!is(typeof(__STATFS_MATCHES_STATFS64))) {
        enum __STATFS_MATCHES_STATFS64 = 1;
    }




    static if(!is(typeof(__RLIM_T_MATCHES_RLIM64_T))) {
        enum __RLIM_T_MATCHES_RLIM64_T = 1;
    }




    static if(!is(typeof(__INO_T_MATCHES_INO64_T))) {
        enum __INO_T_MATCHES_INO64_T = 1;
    }




    static if(!is(typeof(__OFF_T_MATCHES_OFF64_T))) {
        enum __OFF_T_MATCHES_OFF64_T = 1;
    }
    static if(!is(typeof(_BITS_TYPESIZES_H))) {
        enum _BITS_TYPESIZES_H = 1;
    }




    static if(!is(typeof(__timer_t_defined))) {
        enum __timer_t_defined = 1;
    }




    static if(!is(typeof(__time_t_defined))) {
        enum __time_t_defined = 1;
    }






    static if(!is(typeof(__struct_tm_defined))) {
        enum __struct_tm_defined = 1;
    }




    static if(!is(typeof(_STRUCT_TIMESPEC))) {
        enum _STRUCT_TIMESPEC = 1;
    }






    static if(!is(typeof(__sigstack_defined))) {
        enum __sigstack_defined = 1;
    }




    static if(!is(typeof(__itimerspec_defined))) {
        enum __itimerspec_defined = 1;
    }




    static if(!is(typeof(_IO_USER_LOCK))) {
        enum _IO_USER_LOCK = 0x8000;
    }
    static if(!is(typeof(_IO_ERR_SEEN))) {
        enum _IO_ERR_SEEN = 0x0020;
    }






    static if(!is(typeof(_IO_EOF_SEEN))) {
        enum _IO_EOF_SEEN = 0x0010;
    }
    static if(!is(typeof(__struct_FILE_defined))) {
        enum __struct_FILE_defined = 1;
    }




    static if(!is(typeof(__stack_t_defined))) {
        enum __stack_t_defined = 1;
    }






    static if(!is(typeof(II_PLUS))) {
        enum II_PLUS = '+';
    }




    static if(!is(typeof(II_MINUS))) {
        enum II_MINUS = '-';
    }
    static if(!is(typeof(II_STRING_BASE))) {
        enum II_STRING_BASE = 10;
    }




    static if(!is(typeof(II_BITS_PER_DEC_DIGIT))) {
        enum II_BITS_PER_DEC_DIGIT = 3.35;
    }




    static if(!is(typeof(II_DEC_DIGIT_PER_BITS))) {
        enum II_DEC_DIGIT_PER_BITS = 3.32191780821918;
    }




    static if(!is(typeof(II_II_DIGITS_PER_DEC_DIGIT))) {
        enum II_II_DIGITS_PER_DEC_DIGIT = 0.108064516;
    }




    static if(!is(typeof(II_DEC_DIGITS_PER_II_DIGIT))) {
        enum II_DEC_DIGITS_PER_II_DIGIT = 9.253731343;
    }






    static if(!is(typeof(II_BITS_PER_HEX_DIGIT))) {
        enum II_BITS_PER_HEX_DIGIT = 4;
    }




    static if(!is(typeof(II_HEX_BASE))) {
        enum II_HEX_BASE = 16;
    }




    static if(!is(typeof(II_HEX_RADIX_CHARS))) {
        enum II_HEX_RADIX_CHARS = "xX";
    }




    static if(!is(typeof(II_BITS_PER_BINARY_DIGIT))) {
        enum II_BITS_PER_BINARY_DIGIT = 1;
    }




    static if(!is(typeof(II_BINARY_BASE))) {
        enum II_BINARY_BASE = 2;
    }




    static if(!is(typeof(II_BINARY_RADIX_CHARS))) {
        enum II_BINARY_RADIX_CHARS = "bB";
    }






    static if(!is(typeof(II_BITS_PER_BYTE))) {
        enum II_BITS_PER_BYTE = 8;
    }




    static if(!is(typeof(II_BYTE_BASE))) {
        enum II_BYTE_BASE = 256;
    }




    static if(!is(typeof(II_BYTE_MASK))) {
        enum II_BYTE_MASK = 0xFF;
    }




    static if(!is(typeof(II_BYTE_SIGN_BIT))) {
        enum II_BYTE_SIGN_BIT = 0x80;
    }




    static if(!is(typeof(II_BYTE_NEG_OVERFLOW_LIMIT))) {
        enum II_BYTE_NEG_OVERFLOW_LIMIT = 0xFE;
    }
    static if(!is(typeof(__sigset_t_defined))) {
        enum __sigset_t_defined = 1;
    }
    static if(!is(typeof(__SI_HAVE_SIGSYS))) {
        enum __SI_HAVE_SIGSYS = 1;
    }




    static if(!is(typeof(__SI_ERRNO_THEN_CODE))) {
        enum __SI_ERRNO_THEN_CODE = 1;
    }
    static if(!is(typeof(__SI_MAX_SIZE))) {
        enum __SI_MAX_SIZE = 128;
    }




    static if(!is(typeof(__siginfo_t_defined))) {
        enum __siginfo_t_defined = 1;
    }
    static if(!is(typeof(__have_pthread_attr_t))) {
        enum __have_pthread_attr_t = 1;
    }






    static if(!is(typeof(__SIGEV_MAX_SIZE))) {
        enum __SIGEV_MAX_SIZE = 64;
    }




    static if(!is(typeof(__sigevent_t_defined))) {
        enum __sigevent_t_defined = 1;
    }




    static if(!is(typeof(__sig_atomic_t_defined))) {
        enum __sig_atomic_t_defined = 1;
    }




    static if(!is(typeof(_BITS_TYPES_LOCALE_T_H))) {
        enum _BITS_TYPES_LOCALE_T_H = 1;
    }




    static if(!is(typeof(__clockid_t_defined))) {
        enum __clockid_t_defined = 1;
    }




    static if(!is(typeof(__clock_t_defined))) {
        enum __clock_t_defined = 1;
    }
    static if(!is(typeof(____mbstate_t_defined))) {
        enum ____mbstate_t_defined = 1;
    }




    static if(!is(typeof(_BITS_TYPES___LOCALE_T_H))) {
        enum _BITS_TYPES___LOCALE_T_H = 1;
    }




    static if(!is(typeof(_____fpos_t_defined))) {
        enum _____fpos_t_defined = 1;
    }




    static if(!is(typeof(_____fpos64_t_defined))) {
        enum _____fpos64_t_defined = 1;
    }




    static if(!is(typeof(____FILE_defined))) {
        enum ____FILE_defined = 1;
    }




    static if(!is(typeof(__FILE_defined))) {
        enum __FILE_defined = 1;
    }
    static if(!is(typeof(_BITS_TYPES_H))) {
        enum _BITS_TYPES_H = 1;
    }
    static if(!is(typeof(_BITS_TIME64_H))) {
        enum _BITS_TIME64_H = 1;
    }




    static if(!is(typeof(TIMER_ABSTIME))) {
        enum TIMER_ABSTIME = 1;
    }




    static if(!is(typeof(CLOCK_TAI))) {
        enum CLOCK_TAI = 11;
    }




    static if(!is(typeof(CLOCK_BOOTTIME_ALARM))) {
        enum CLOCK_BOOTTIME_ALARM = 9;
    }




    static if(!is(typeof(CLOCK_REALTIME_ALARM))) {
        enum CLOCK_REALTIME_ALARM = 8;
    }




    static if(!is(typeof(CLOCK_BOOTTIME))) {
        enum CLOCK_BOOTTIME = 7;
    }




    static if(!is(typeof(CLOCK_MONOTONIC_COARSE))) {
        enum CLOCK_MONOTONIC_COARSE = 6;
    }




    static if(!is(typeof(CLOCK_REALTIME_COARSE))) {
        enum CLOCK_REALTIME_COARSE = 5;
    }




    static if(!is(typeof(CLOCK_MONOTONIC_RAW))) {
        enum CLOCK_MONOTONIC_RAW = 4;
    }




    static if(!is(typeof(CLOCK_THREAD_CPUTIME_ID))) {
        enum CLOCK_THREAD_CPUTIME_ID = 3;
    }




    static if(!is(typeof(CLOCK_PROCESS_CPUTIME_ID))) {
        enum CLOCK_PROCESS_CPUTIME_ID = 2;
    }




    static if(!is(typeof(CLOCK_MONOTONIC))) {
        enum CLOCK_MONOTONIC = 1;
    }




    static if(!is(typeof(CLOCK_REALTIME))) {
        enum CLOCK_REALTIME = 0;
    }






    static if(!is(typeof(_BITS_TIME_H))) {
        enum _BITS_TIME_H = 1;
    }




    static if(!is(typeof(_THREAD_SHARED_TYPES_H))) {
        enum _THREAD_SHARED_TYPES_H = 1;
    }
    static if(!is(typeof(__PTHREAD_MUTEX_HAVE_PREV))) {
        enum __PTHREAD_MUTEX_HAVE_PREV = 1;
    }




    static if(!is(typeof(_THREAD_MUTEX_INTERNAL_H))) {
        enum _THREAD_MUTEX_INTERNAL_H = 1;
    }




    static if(!is(typeof(FOPEN_MAX))) {
        enum FOPEN_MAX = 16;
    }




    static if(!is(typeof(L_ctermid))) {
        enum L_ctermid = 9;
    }




    static if(!is(typeof(FILENAME_MAX))) {
        enum FILENAME_MAX = 4096;
    }




    static if(!is(typeof(TMP_MAX))) {
        enum TMP_MAX = 238328;
    }




    static if(!is(typeof(L_tmpnam))) {
        enum L_tmpnam = 20;
    }




    static if(!is(typeof(_BITS_STDIO_LIM_H))) {
        enum _BITS_STDIO_LIM_H = 1;
    }




    static if(!is(typeof(_BITS_STDINT_UINTN_H))) {
        enum _BITS_STDINT_UINTN_H = 1;
    }




    static if(!is(typeof(_BITS_STDINT_INTN_H))) {
        enum _BITS_STDINT_INTN_H = 1;
    }
    static if(!is(typeof(_BITS_SS_FLAGS_H))) {
        enum _BITS_SS_FLAGS_H = 1;
    }




    static if(!is(typeof(_BITS_SIGTHREAD_H))) {
        enum _BITS_SIGTHREAD_H = 1;
    }




    static if(!is(typeof(SIGSTKSZ))) {
        enum SIGSTKSZ = 8192;
    }




    static if(!is(typeof(MINSIGSTKSZ))) {
        enum MINSIGSTKSZ = 2048;
    }




    static if(!is(typeof(_BITS_SIGSTACK_H))) {
        enum _BITS_SIGSTACK_H = 1;
    }




    static if(!is(typeof(__SIGRTMAX))) {
        enum __SIGRTMAX = 64;
    }




    static if(!is(typeof(SIGSYS))) {
        enum SIGSYS = 31;
    }




    static if(!is(typeof(SIGPOLL))) {
        enum SIGPOLL = 29;
    }




    static if(!is(typeof(SIGURG))) {
        enum SIGURG = 23;
    }






    static if(!is(typeof(SIGTSTP))) {
        enum SIGTSTP = 20;
    }






    static if(!is(typeof(SIGSTOP))) {
        enum SIGSTOP = 19;
    }
    static if(!is(typeof(SIGCONT))) {
        enum SIGCONT = 18;
    }




    static if(!is(typeof(SIGCHLD))) {
        enum SIGCHLD = 17;
    }




    static if(!is(typeof(SIGUSR2))) {
        enum SIGUSR2 = 12;
    }




    static if(!is(typeof(SIGUSR1))) {
        enum SIGUSR1 = 10;
    }




    static if(!is(typeof(SIGBUS))) {
        enum SIGBUS = 7;
    }




    static if(!is(typeof(SIGPWR))) {
        enum SIGPWR = 30;
    }




    static if(!is(typeof(SIGSTKFLT))) {
        enum SIGSTKFLT = 16;
    }




    static if(!is(typeof(_BITS_SIGNUM_H))) {
        enum _BITS_SIGNUM_H = 1;
    }






    static if(!is(typeof(__SIGRTMIN))) {
        enum __SIGRTMIN = 32;
    }
    static if(!is(typeof(SIGWINCH))) {
        enum SIGWINCH = 28;
    }




    static if(!is(typeof(SIGPROF))) {
        enum SIGPROF = 27;
    }




    static if(!is(typeof(SIGVTALRM))) {
        enum SIGVTALRM = 26;
    }




    static if(!is(typeof(SIGXFSZ))) {
        enum SIGXFSZ = 25;
    }




    static if(!is(typeof(SIGXCPU))) {
        enum SIGXCPU = 24;
    }




    static if(!is(typeof(SIGTTOU))) {
        enum SIGTTOU = 22;
    }




    static if(!is(typeof(SIGTTIN))) {
        enum SIGTTIN = 21;
    }




    static if(!is(typeof(SIGALRM))) {
        enum SIGALRM = 14;
    }




    static if(!is(typeof(SIGPIPE))) {
        enum SIGPIPE = 13;
    }




    static if(!is(typeof(SIGKILL))) {
        enum SIGKILL = 9;
    }




    static if(!is(typeof(SIGTRAP))) {
        enum SIGTRAP = 5;
    }




    static if(!is(typeof(SIGQUIT))) {
        enum SIGQUIT = 3;
    }




    static if(!is(typeof(SIGHUP))) {
        enum SIGHUP = 1;
    }




    static if(!is(typeof(SIGTERM))) {
        enum SIGTERM = 15;
    }




    static if(!is(typeof(SIGSEGV))) {
        enum SIGSEGV = 11;
    }




    static if(!is(typeof(SIGFPE))) {
        enum SIGFPE = 8;
    }




    static if(!is(typeof(SIGABRT))) {
        enum SIGABRT = 6;
    }




    static if(!is(typeof(SIGILL))) {
        enum SIGILL = 4;
    }




    static if(!is(typeof(SIGINT))) {
        enum SIGINT = 2;
    }
    static if(!is(typeof(_BITS_SIGNUM_GENERIC_H))) {
        enum _BITS_SIGNUM_GENERIC_H = 1;
    }
    static if(!is(typeof(__SI_ASYNCIO_AFTER_SIGIO))) {
        enum __SI_ASYNCIO_AFTER_SIGIO = 1;
    }




    static if(!is(typeof(_BITS_SIGINFO_CONSTS_H))) {
        enum _BITS_SIGINFO_CONSTS_H = 1;
    }




    static if(!is(typeof(_BITS_SIGINFO_ARCH_H))) {
        enum _BITS_SIGINFO_ARCH_H = 1;
    }
    static if(!is(typeof(_BITS_SIGEVENT_CONSTS_H))) {
        enum _BITS_SIGEVENT_CONSTS_H = 1;
    }






    static if(!is(typeof(FP_XSTATE_MAGIC2))) {
        enum FP_XSTATE_MAGIC2 = 0x46505845U;
    }




    static if(!is(typeof(FP_XSTATE_MAGIC1))) {
        enum FP_XSTATE_MAGIC1 = 0x46505853U;
    }




    static if(!is(typeof(_BITS_SIGCONTEXT_H))) {
        enum _BITS_SIGCONTEXT_H = 1;
    }




    static if(!is(typeof(SIG_SETMASK))) {
        enum SIG_SETMASK = 2;
    }




    static if(!is(typeof(SIG_UNBLOCK))) {
        enum SIG_UNBLOCK = 1;
    }




    static if(!is(typeof(SIG_BLOCK))) {
        enum SIG_BLOCK = 0;
    }
    static if(!is(typeof(SA_INTERRUPT))) {
        enum SA_INTERRUPT = 0x20000000;
    }




    static if(!is(typeof(SA_RESETHAND))) {
        enum SA_RESETHAND = 0x80000000;
    }




    static if(!is(typeof(SA_NODEFER))) {
        enum SA_NODEFER = 0x40000000;
    }




    static if(!is(typeof(SA_RESTART))) {
        enum SA_RESTART = 0x10000000;
    }




    static if(!is(typeof(SA_ONSTACK))) {
        enum SA_ONSTACK = 0x08000000;
    }




    static if(!is(typeof(SA_SIGINFO))) {
        enum SA_SIGINFO = 4;
    }




    static if(!is(typeof(SA_NOCLDWAIT))) {
        enum SA_NOCLDWAIT = 2;
    }




    static if(!is(typeof(SA_NOCLDSTOP))) {
        enum SA_NOCLDSTOP = 1;
    }
    static if(!is(typeof(_BITS_SIGACTION_H))) {
        enum _BITS_SIGACTION_H = 1;
    }




    static if(!is(typeof(_BITS_PTHREADTYPES_COMMON_H))) {
        enum _BITS_PTHREADTYPES_COMMON_H = 1;
    }
    static if(!is(typeof(__SIZEOF_PTHREAD_BARRIERATTR_T))) {
        enum __SIZEOF_PTHREAD_BARRIERATTR_T = 4;
    }




    static if(!is(typeof(__SIZEOF_PTHREAD_RWLOCKATTR_T))) {
        enum __SIZEOF_PTHREAD_RWLOCKATTR_T = 8;
    }




    static if(!is(typeof(__SIZEOF_PTHREAD_CONDATTR_T))) {
        enum __SIZEOF_PTHREAD_CONDATTR_T = 4;
    }




    static if(!is(typeof(__SIZEOF_PTHREAD_COND_T))) {
        enum __SIZEOF_PTHREAD_COND_T = 48;
    }




    static if(!is(typeof(__SIZEOF_PTHREAD_MUTEXATTR_T))) {
        enum __SIZEOF_PTHREAD_MUTEXATTR_T = 4;
    }




    static if(!is(typeof(__SIZEOF_PTHREAD_BARRIER_T))) {
        enum __SIZEOF_PTHREAD_BARRIER_T = 32;
    }




    static if(!is(typeof(__SIZEOF_PTHREAD_RWLOCK_T))) {
        enum __SIZEOF_PTHREAD_RWLOCK_T = 56;
    }




    static if(!is(typeof(__SIZEOF_PTHREAD_ATTR_T))) {
        enum __SIZEOF_PTHREAD_ATTR_T = 56;
    }




    static if(!is(typeof(__SIZEOF_PTHREAD_MUTEX_T))) {
        enum __SIZEOF_PTHREAD_MUTEX_T = 40;
    }




    static if(!is(typeof(_BITS_PTHREADTYPES_ARCH_H))) {
        enum _BITS_PTHREADTYPES_ARCH_H = 1;
    }




    static if(!is(typeof(__LONG_DOUBLE_USES_FLOAT128))) {
        enum __LONG_DOUBLE_USES_FLOAT128 = 0;
    }




    static if(!is(typeof(__GLIBC_USE_IEC_60559_TYPES_EXT))) {
        enum __GLIBC_USE_IEC_60559_TYPES_EXT = 0;
    }




    static if(!is(typeof(__GLIBC_USE_IEC_60559_FUNCS_EXT_C2X))) {
        enum __GLIBC_USE_IEC_60559_FUNCS_EXT_C2X = 0;
    }




    static if(!is(typeof(__GLIBC_USE_IEC_60559_FUNCS_EXT))) {
        enum __GLIBC_USE_IEC_60559_FUNCS_EXT = 0;
    }




    static if(!is(typeof(__GLIBC_USE_IEC_60559_BFP_EXT_C2X))) {
        enum __GLIBC_USE_IEC_60559_BFP_EXT_C2X = 0;
    }




    static if(!is(typeof(__GLIBC_USE_IEC_60559_BFP_EXT))) {
        enum __GLIBC_USE_IEC_60559_BFP_EXT = 0;
    }




    static if(!is(typeof(__GLIBC_USE_LIB_EXT2))) {
        enum __GLIBC_USE_LIB_EXT2 = 0;
    }






    static if(!is(typeof(_BITS_ENDIANNESS_H))) {
        enum _BITS_ENDIANNESS_H = 1;
    }
    static if(!is(typeof(__PDP_ENDIAN))) {
        enum __PDP_ENDIAN = 3412;
    }




    static if(!is(typeof(__BIG_ENDIAN))) {
        enum __BIG_ENDIAN = 4321;
    }




    static if(!is(typeof(__LITTLE_ENDIAN))) {
        enum __LITTLE_ENDIAN = 1234;
    }




    static if(!is(typeof(_BITS_ENDIAN_H))) {
        enum _BITS_ENDIAN_H = 1;
    }






    static if(!is(typeof(DEFAULT_STRING_LENGTH))) {
        enum DEFAULT_STRING_LENGTH = 8;
    }
    static if(!is(typeof(ION_SYS_SYMBOL_SHARED_SYMBOL_TABLE))) {
        enum ION_SYS_SYMBOL_SHARED_SYMBOL_TABLE = "$ion_shared_symbol_table";
    }




    static if(!is(typeof(ION_SYS_STRLEN_SHARED_SYMBOL_TABLE))) {
        enum ION_SYS_STRLEN_SHARED_SYMBOL_TABLE = 24;
    }




    static if(!is(typeof(ION_SYS_SYMBOL_ION))) {
        enum ION_SYS_SYMBOL_ION = "$ion";
    }




    static if(!is(typeof(ION_SYS_SYMBOL_IVM))) {
        enum ION_SYS_SYMBOL_IVM = "$ion_1_0";
    }




    static if(!is(typeof(ION_SYS_SYMBOL_ION_SYMBOL_TABLE))) {
        enum ION_SYS_SYMBOL_ION_SYMBOL_TABLE = "$ion_symbol_table";
    }




    static if(!is(typeof(ION_SYS_SYMBOL_NAME))) {
        enum ION_SYS_SYMBOL_NAME = "name";
    }




    static if(!is(typeof(ION_SYS_SYMBOL_VERSION))) {
        enum ION_SYS_SYMBOL_VERSION = "version";
    }




    static if(!is(typeof(ION_SYS_SYMBOL_IMPORTS))) {
        enum ION_SYS_SYMBOL_IMPORTS = "imports";
    }




    static if(!is(typeof(ION_SYS_SYMBOL_SYMBOLS))) {
        enum ION_SYS_SYMBOL_SYMBOLS = "symbols";
    }




    static if(!is(typeof(ION_SYS_SYMBOL_MAX_ID))) {
        enum ION_SYS_SYMBOL_MAX_ID = "max_id";
    }






    static if(!is(typeof(ION_SYS_SID_ION))) {
        enum ION_SYS_SID_ION = 1;
    }




    static if(!is(typeof(ION_SYS_SID_IVM))) {
        enum ION_SYS_SID_IVM = 2;
    }




    static if(!is(typeof(ION_SYS_SID_SYMBOL_TABLE))) {
        enum ION_SYS_SID_SYMBOL_TABLE = 3;
    }




    static if(!is(typeof(ION_SYS_SID_NAME))) {
        enum ION_SYS_SID_NAME = 4;
    }




    static if(!is(typeof(ION_SYS_SID_VERSION))) {
        enum ION_SYS_SID_VERSION = 5;
    }




    static if(!is(typeof(ION_SYS_SID_IMPORTS))) {
        enum ION_SYS_SID_IMPORTS = 6;
    }




    static if(!is(typeof(ION_SYS_SID_SYMBOLS))) {
        enum ION_SYS_SID_SYMBOLS = 7;
    }




    static if(!is(typeof(ION_SYS_SID_MAX_ID))) {
        enum ION_SYS_SID_MAX_ID = 8;
    }




    static if(!is(typeof(ION_SYS_SID_SHARED_SYMBOL_TABLE))) {
        enum ION_SYS_SID_SHARED_SYMBOL_TABLE = 9;
    }




    static if(!is(typeof(ION_SYS_STRLEN_ION))) {
        enum ION_SYS_STRLEN_ION = 4;
    }




    static if(!is(typeof(ION_SYS_STRLEN_IVM))) {
        enum ION_SYS_STRLEN_IVM = 8;
    }




    static if(!is(typeof(ION_SYS_STRLEN_SYMBOL_TABLE))) {
        enum ION_SYS_STRLEN_SYMBOL_TABLE = 17;
    }




    static if(!is(typeof(ION_SYS_STRLEN_NAME))) {
        enum ION_SYS_STRLEN_NAME = 4;
    }




    static if(!is(typeof(ION_SYS_STRLEN_VERSION))) {
        enum ION_SYS_STRLEN_VERSION = 7;
    }




    static if(!is(typeof(ION_SYS_STRLEN_IMPORTS))) {
        enum ION_SYS_STRLEN_IMPORTS = 7;
    }




    static if(!is(typeof(ION_SYS_STRLEN_SYMBOLS))) {
        enum ION_SYS_STRLEN_SYMBOLS = 7;
    }




    static if(!is(typeof(ION_SYS_STRLEN_MAX_ID))) {
        enum ION_SYS_STRLEN_MAX_ID = 6;
    }






    static if(!is(typeof(ION_TT_BIT_YEAR))) {
        enum ION_TT_BIT_YEAR = 0x01;
    }




    static if(!is(typeof(ION_TT_BIT_MONTH))) {
        enum ION_TT_BIT_MONTH = 0x02;
    }




    static if(!is(typeof(ION_TT_BIT_DAY))) {
        enum ION_TT_BIT_DAY = 0x04;
    }




    static if(!is(typeof(ION_TT_BIT_MIN))) {
        enum ION_TT_BIT_MIN = 0x10;
    }




    static if(!is(typeof(ION_TT_BIT_SEC))) {
        enum ION_TT_BIT_SEC = 0x20;
    }




    static if(!is(typeof(ION_TT_BIT_FRAC))) {
        enum ION_TT_BIT_FRAC = 0x40;
    }
    static if(!is(typeof(TRUE))) {
        enum TRUE = 1;
    }




    static if(!is(typeof(FALSE))) {
        enum FALSE = 0;
    }




    static if(!is(typeof(MAX_INT32))) {
        enum MAX_INT32 = 0x7FFFFFFF;
    }






    static if(!is(typeof(MAX_INT64))) {
        enum MAX_INT64 = 0x7FFFFFFFFFFFFFFFL;
    }
    static if(!is(typeof(tid_NULL_INT))) {
        enum tid_NULL_INT = 0x000;
    }




    static if(!is(typeof(tid_BOOL_INT))) {
        enum tid_BOOL_INT = 0x100;
    }




    static if(!is(typeof(tid_INT_INT))) {
        enum tid_INT_INT = 0x200;
    }




    static if(!is(typeof(tid_FLOAT_INT))) {
        enum tid_FLOAT_INT = 0x400;
    }




    static if(!is(typeof(tid_DECIMAL_INT))) {
        enum tid_DECIMAL_INT = 0x500;
    }




    static if(!is(typeof(tid_TIMESTAMP_INT))) {
        enum tid_TIMESTAMP_INT = 0x600;
    }




    static if(!is(typeof(tid_SYMBOL_INT))) {
        enum tid_SYMBOL_INT = 0x700;
    }




    static if(!is(typeof(tid_STRING_INT))) {
        enum tid_STRING_INT = 0x800;
    }




    static if(!is(typeof(tid_CLOB_INT))) {
        enum tid_CLOB_INT = 0x900;
    }




    static if(!is(typeof(tid_BLOB_INT))) {
        enum tid_BLOB_INT = 0xA00;
    }




    static if(!is(typeof(tid_LIST_INT))) {
        enum tid_LIST_INT = 0xB00;
    }




    static if(!is(typeof(tid_SEXP_INT))) {
        enum tid_SEXP_INT = 0xC00;
    }




    static if(!is(typeof(tid_STRUCT_INT))) {
        enum tid_STRUCT_INT = 0xD00;
    }




    static if(!is(typeof(tid_DATAGRAM_INT))) {
        enum tid_DATAGRAM_INT = 0xF00;
    }






}


struct __va_list_tag;
