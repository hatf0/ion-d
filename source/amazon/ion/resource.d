module amazon.ion.resource;
public import std.experimental.allocator : theAllocator, make, dispose;

struct SharedResource
{
@safe:
    alias Exception function(shared(void)*) nothrow Release;

    this(shared(void)* ptr, Release release) @trusted
        in { assert(ptr); } body
    {
        auto p = theAllocator.make!(shared(Payload));
        p.refCount = 1;
        p.handle = ptr;
        p.release = release;
        m_payload = p;
    }

    this(this) nothrow
    {
        if (m_payload) {
            incRefCount();
        }
    }

    ~this() nothrow
    {
        nothrowDetach();
    }

    void opAssign(SharedResource rhs)
    {
        detach();
        m_payload = rhs.m_payload;
        rhs.m_payload = null;

    }

    void detach()
    {
        if (auto ex = nothrowDetach()) throw ex;
    }

    void forceRelease() @system
    {
        if (m_payload) {
            scope(exit) {
                theAllocator.dispose(m_payload);
                m_payload = null;
            }
            decRefCount();
            if (m_payload.handle != null) {
                scope(exit) m_payload.handle = null;
                if (auto ex = m_payload.release(m_payload.handle)) {
                    throw ex;
                }
            }
        }
    }

    @property inout(shared(void))* handle() inout pure nothrow
    {
        if (m_payload) {
            return m_payload.handle;
        } else {
            return null;
        }
    }

private:
    void incRefCount() @trusted nothrow
    {
        assert (m_payload !is null && m_payload.refCount > 0);
        import core.atomic: atomicOp;
        atomicOp!"+="(m_payload.refCount, 1);
    }

    int decRefCount() @trusted nothrow
    {
        assert (m_payload !is null && m_payload.refCount > 0);
        import core.atomic: atomicOp;
        return atomicOp!"-="(m_payload.refCount, 1);
    }

    Exception nothrowDetach() @trusted nothrow
        out { assert (m_payload is null); }
        body
    {
        if (m_payload) {
            scope(exit) {() {
                try {
                    theAllocator.dispose(m_payload);
                } catch(Exception e) { assert(0); }
                
                m_payload = null;
            }();}
            if (decRefCount() < 1 && m_payload.handle != null) {
                return m_payload.release(m_payload.handle);
            }
        }
        return null;
    }

    struct Payload
    {
        int refCount;
        void* handle;
        Release release;
    }
    shared(Payload)* m_payload;

    invariant()
    {
        assert (m_payload is null ||
            (m_payload.refCount > 0 && m_payload.release !is null));
    }
}
