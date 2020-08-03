module amazon.ion.logger;
import std.datetime; 
import core.thread;

enum Verbosity {
    Debug = 0,
    Info = 1,
    Error = 2
};

import std.array, std.format;
static shared Logger _ionLogger;

void INFO(string format, string file = __MODULE__, int line = __LINE__, A...)(lazy A args) @trusted {
    if (_ionLogger.__minVerbosity <= Verbosity.Info) {
        auto msg = appender!string;
        formattedWrite(msg, format, args);
        _ionLogger.log(Verbosity.Info, msg.data, file, line);
    }
}

void DEBUG(string format, string file = __MODULE__, int line = __LINE__, A...)(lazy A args) @trusted {
    if (_ionLogger.__minVerbosity <= Verbosity.Debug) {
        auto msg = appender!string;
        formattedWrite(msg, format, args);
        _ionLogger.log(Verbosity.Debug, msg.data, file, line);
    }
}

void ERROR(string format, string file = __MODULE__, int line = __LINE__, A...)(lazy A args) @trusted {
    if (_ionLogger.__minVerbosity <= Verbosity.Error) {
        auto msg = appender!string;
        formattedWrite(msg, format, args);
        _ionLogger.log(Verbosity.Error, msg.data, file, line);
    }
}

class Logger {
    private {
        string _infoPath;
        string _warningPath;
        string _errorPath;
        string _debugPath;

        Verbosity __minVerbosity;

    }

    @property Verbosity minVerbosity() shared {
        return __minVerbosity;
    }

    @property Verbosity minVerbosity(Verbosity _min) shared {
        __minVerbosity = _min;
        return _min;
    }
    
    void info(string message, string file = __MODULE__, int line = __LINE__) shared {
        log(Verbosity.Info, message, file, line);
    }

    void debug_(string message, string file = __MODULE__, int line = __LINE__)  shared{
        log(Verbosity.Debug, message, file, line);
    }

    void error(string message, string file = __MODULE__, int line = __LINE__) shared {
        log(Verbosity.Error, message, file, line);
    }

    void log(Verbosity v, string message, string file = __MODULE__, int line = __LINE__) shared {
        import std.stdio;
        import std.conv : to;
        import std.string;
        import std.datetime;
        if (minVerbosity <= v) {
            writefln("%s [%s][%s:%d]: %s", to!string(v).toUpper(), Clock.currTime().toISOExtString(), file, line, message); 
        }
    }

    this(Verbosity _minVerbosity = Verbosity.Info, string info = "", string warning = "", string error = "", string debug_ = "") shared {
        minVerbosity = _minVerbosity;
        _infoPath = info;
        _warningPath = warning;
        _errorPath = error;
        _debugPath = debug_;
    }

    shared static this() {
        _ionLogger = new shared(Logger)();
        import core.exception;
        core.exception.assertHandler = &assertHandler;
    }
    
    shared static ~this() {
        destroy(_ionLogger);
    }
}

import core.stdc.stdlib : abort;
import core.thread;
import core.time;

void assertHandler(string file, ulong line, string message) nothrow {
    try { 
        ERROR!"ASSERT: %s at %s:%d"(message, file, line);
        abort();
    } catch(Exception e) {

    }
}
