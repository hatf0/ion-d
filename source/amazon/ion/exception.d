module amazon.ion.exception;
import amazon.ion.c : ion_error_code;

class IonException : Exception {
    this(ion_error_code c, string file = __FILE__, ulong line = cast(ulong)__LINE__) nothrow @safe @nogc {
        import std.traits : EnumMembers;
        /* Avoid doing this string conversion at runtime, have the compiler generate it for us */
        static foreach(i, member; EnumMembers!(ion_error_code)) {{
            enum STR = __traits(identifier, EnumMembers!(ion_error_code)[i]);
            if (c == member) {
                super("Ion exception: " ~ STR, file, line);
                return;
            }
        }}

        /* If you ever get this, the bindings probably need to be updated.. */
        assert(0, "IonException was created with an ion_error_code which was invalid");
    }
}
