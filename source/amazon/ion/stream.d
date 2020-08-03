module amazon.ion.stream;
import amazon.ion.c;
import amazon.ion.logger;
import amazon.ion.resource;
import amazon.ion.exception;
import std.experimental.allocator : theAllocator, make, dispose;

/* Name is misleading, but this is just generic preconditions that every getter/helper function should fulfill */

template AssertNullHandle() {
    const char[] AssertNullHandle = "assert(valid(), \"Expected valid stream\"); assert(_closed != true, \"Should not be closed\");";
}

class IonStream {
    private {
        SharedResource _stream;
        bool _closed;
        static Exception release(shared(void)* ptr) @trusted nothrow {
            Exception ret = null;
            ION_STREAM** _s = cast(ION_STREAM**)ptr;
            if (_s != null) {
                if (*_s != null) {
                    ion_error_code c = ion_stream_close(*_s);
                    if (c != IERR_OK) {
                        ret = new IonException(c);
                    }
                }

                theAllocator.dispose(_s);
            }
            return ret;
        }
    }

    @property inout(ION_STREAM)* unsafeHandle() inout @trusted pure nothrow {
        return cast(typeof(return)) *handle();
    }

    @property inout(ION_STREAM)** handle() inout @trusted pure nothrow {
        return cast(typeof(return)) _stream.handle;
    }

    @property bool valid() {
        return *handle() != null;
    }

    // TODO: investigate why mark seems to give a link error?
    /* once again, generate this boilerplate at compile time */
    import std.algorithm.iteration : map;
    import std.string : capitalize, strip, replace, split;
    static foreach(can; ["read", "write", "seek"/*, "mark"*/]) {
        mixin("
            @property bool can" ~ can.capitalize() ~ " () in {
                mixin(AssertNullHandle!());
            } body {
                return ion_stream_can_" ~ can ~ "(unsafeHandle()) == true;
            }
        ");
    }

    static foreach(get; ["position", "mark_start", "marked_length"]) {
        mixin("
            @property POSITION " ~ get ~ "() in {
                mixin(AssertNullHandle!());
            } body {
                return ion_stream_get_" ~ get ~ "(unsafeHandle());
            }
        ");
    }

    @property FILE* file_stream() in {
        mixin(AssertNullHandle!());
    } body {
        return ion_stream_get_file_stream(unsafeHandle());
    }

    @property bool dirty() in {
        mixin(AssertNullHandle!());
    } body {
        return ion_stream_is_dirty(unsafeHandle()) == true;
    }

    @property bool mark_open() in {
        mixin(AssertNullHandle!());
    } body {
        return ion_stream_is_mark_open(unsafeHandle()) == true;
    }

    /* Explicit close isn't usually needed, but it's left here *just* in case */
    ion_error_code close() in {
        mixin(AssertNullHandle!());
    } body {
        _closed = true;
        return ion_stream_close(unsafeHandle());
    }

    ion_error_code flush() in {
        mixin(AssertNullHandle!());
    } body {
        return ion_stream_flush(unsafeHandle());
    }

    /* generic compiler expansion, don't want to rewrite the same piece of code multiple times */
    static foreach(std; ["memory_only", "stdin", "stdout", "stderr"]) {
        mixin("
        static IonStream " ~ std ~ " () {
            { 
                ION_STREAM** _r = theAllocator.make!(ION_STREAM*);
                ion_error_code c;
                if ((c = ion_stream_open_" ~ std ~ "(_r)) == IERR_OK) { 
                    IonStream r = theAllocator.make!(IonStream)(_r);
                    return r;
                } else {
                    throw new IonException(c);
                }
            }
        }
        ");
    }

    int read(ref ubyte[] buf) in {
        mixin(AssertNullHandle!());
        assert(canRead, "Should be able to read");
    } body {
        int bytes_read = 0;
        ion_error_code c = ion_stream_read(unsafeHandle(), buf.ptr, cast(int)buf.length, &bytes_read);
        if (c != IERR_OK) {
            throw new IonException(c);
        }
        return bytes_read;
    }

    int readByte() in {
        mixin(AssertNullHandle!());
        assert(canRead, "Should be able to read");
    } body {
        int bit = 0;
        ion_error_code c = ion_stream_read_byte(unsafeHandle(), cast(int*)&bit);
        if (c != IERR_OK) {
            throw new IonException(c);
        }
        return bit;
    }

    void unreadByte(int bit) in {
        mixin(AssertNullHandle!());
        assert(canRead, "Should be able to read");
    } body {
        ion_error_code c = ion_stream_unread_byte(unsafeHandle(), bit);
        if (c != IERR_OK) {
            throw new IonException(c);
        }
    }

    int write(ubyte[] buf) in {
        mixin(AssertNullHandle!());
        assert(canWrite, "Should be able to write");
    } body {
        int bytes_written = 0;
        ion_error_code c = ion_stream_write(unsafeHandle(), buf.ptr, cast(int)buf.length, &bytes_written);
        if (c != IERR_OK) {
            throw new IonException(c);
        }
        return bytes_written;
    }

    void writeByte(int bit) in {
        mixin(AssertNullHandle!());
        assert(canWrite, "Should be able to write");
    } body {
        ion_error_code c = ion_stream_write_byte(unsafeHandle(), bit);
        if (c != IERR_OK) {
            throw new IonException(c);
        }

    }

    void writeByteNoChecks(int bit) in {
        mixin(AssertNullHandle!());
        assert(canWrite, "Should be able to write");
    } body {
        ion_error_code c = ion_stream_write_byte_no_checks(unsafeHandle(), bit);
        if (c != IERR_OK) {
            throw new IonException(c);
        }
    }

    int writeStream(IonStream input, int length) in {
        mixin(AssertNullHandle!());
        assert(input.handle != null, "Input should not be null");
        assert(input.valid, "Input should be valid");
        assert(canWrite, "Should be able to write");
        assert(input.canWrite, "Should be able to write (2)");
    } body {
        int bytes_written = 0;
        ion_error_code c = ion_stream_write_stream(unsafeHandle(), input.unsafeHandle(), length, &bytes_written);
        if (c != IERR_OK) {
            throw new IonException(c);
        }
        return bytes_written;
    }

    void seek(int position) in {
        mixin(AssertNullHandle!());
        assert(canSeek, "Should be able to seek");
    } body {
        ion_error_code c = ion_stream_seek(unsafeHandle(), position);
        if (c != IERR_OK) {
            throw new IonException(c);
        }
    }

    int skip(int distance) in {
        mixin(AssertNullHandle!());
        assert(canSeek, "Should be able to seek");
    } body {
        int bytes_skipped = 0;
        ion_error_code c = ion_stream_skip(unsafeHandle(), distance, &bytes_skipped);
        if (c != IERR_OK) {
            throw new IonException(c);
        }
        return bytes_skipped;
    }


    void truncate() in {
        mixin(AssertNullHandle!());
    } body {
        ion_error_code c = ion_stream_truncate(unsafeHandle());
        if (c != IERR_OK) {
            throw new IonException(c);
        }
    }


    import std.stdio : File;
    static IonStream fromFile(FileType, string Dir, bool Cache = false)(FileType f) 
    if (is(FileType == int) || is(FileType == File)) {
        static if ((Dir == "In" || Dir == "Out")) {
            ION_STREAM** _r = theAllocator.make!(ION_STREAM*);
            ion_error_code c;
            static if(Dir == "In") {
                static if(is(FileType == File)) {
                    c = ion_stream_open_file_in(cast(FILE*)f.getFP(), _r);
                } else {
                    c = ion_stream_open_fd_in(f, _r);
                }
            }
            else static if(Dir == "Out") {
                static if (is(FileType == File)) {
                    c = ion_stream_open_file_out(cast(FILE*)f.getFP(), _r);
                } else {
                    c = ion_stream_open_fd_out(f, _r);
                }
            }

            if (c == IERR_OK) {
                IonStream r = theAllocator.make!(IonStream)(_r);
                return r;
            } else {
                throw new IonException(c);
            }
        }
        else static if (Dir == "InOut") {
            ION_STREAM* _r;
            ion_error_code c;
            static if (is(FileType == File)) {
                c = ion_stream_open_file_rw(cast(FILE*)f.getFP(), Cache, &_r);
            } else {
                c = ion_stream_open_fd_rw(f, Cache, &_r);
            }

            if (c == IERR_OK) {
                IonStream r = theAllocator.make!(IonStream)(_r);
                return r;
            } else {
                throw new IonException(c);
            }
        }
    }


    static IonStream fromHandler(ION_STREAM_HANDLER handler, string Dir)(ref _ion_user_stream ctx) 
    if (Dir == "In" || Dir == "Out") {
        ION_STREAM** _r = theAllocator.make!(ION_STREAM*);
        ion_error_code c;
        static if (Dir == "In") {
            c = ion_stream_open_handler_in(&handler, &ctx, _r);
        } else {
            c = ion_stream_open_handler_out(&handler, &ctx, _r);
        }

        if (c == IERR_OK) {
            IonStream r = theAllocator.make!(IonStream)(_r);
            return r;
        } else {
            throw new IonException(c);
        }
    }

    static IonStream fromBuffer(ubyte* buf, SIZE buf_len, SIZE buf_filled, bool read_only) {
        ION_STREAM** _r = theAllocator.make!(ION_STREAM*);
        ion_error_code c;
        if ((c = ion_stream_open_buffer(buf, buf_len, buf_filled, cast(int)read_only, _r)) == IERR_OK) {
            IonStream r = theAllocator.make!(IonStream)(_r);
            return r;
        }
        throw new IonException(c);
    }

    this(ION_STREAM** _r) {
        _stream = SharedResource(cast(shared)_r, &release);
    }

    ~this() {

    }
}

@("Memory only open")
unittest {
    IonStream s = IonStream.memory_only();
    assert(s.handle() != null, "Handle should not be null");
    assert(s.unsafeHandle() != null, "Unsafe handle should not be null");
    assert(s.canRead == true, "Should be able to read");
    assert(s.canWrite == true, "Should be able to write");
    assert(s.canSeek == true, "Should be able to seek");
    assert(s.dirty == false, "Should not be dirty");
    assert(s.mark_open == false, "Is mark open?");
    assert(s.close() == IERR_OK, "Should not error");
    bool caught = false;
    try {
        s._stream.detach();
    } catch(IonException e) {
        caught = true;
    }

    /// TODO: is this an error?
    assert(!caught, "Shouldn't error if closed twice");
}

@("Stderr open (via handler)")
unittest {

}


@("Stderr open (via fromFile)")
unittest {
    import std.stdio : File, stderr;
    IonStream s = IonStream.fromFile!(File, "Out")(stderr);
    assert(s.handle() != null, "Handle should not be null");
    assert(s.unsafeHandle() != null, "Unsafe handle should not be null");
    assert(s.canWrite == true, "Should be able to write");
    assert(s.canRead == false, "Should not be able to read");
    assert(s.canSeek == true, "Should be able to seek (?)");
    assert(s.dirty == false, "Should not be dirty");
    assert(s.mark_open == false, "Mark should not be open");
    assert(s.close() == IERR_OK, "Should not error on close");
}


