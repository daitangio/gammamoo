#include "options.h"

#ifdef MOO_GCRYPT

#include <stdio.h>

#include <gcrypt.h>

#include "functions.h"
#include "list.h"
#include "log.h"
#include "storage.h"
#include "streams.h"
#include "structures.h"
#include "utils.h"

package
hash_bytes(Var arglist, const char *buf, size_t buflen)
{
    Var r;
    int algo, hash_size, i;
    unsigned char *hash, *hexdigest;

    if (arglist.v.list[0].v.num > 1) {
        algo = gcry_md_map_name(arglist.v.list[2].v.str);
        if (!algo) {
	    Var v = var_ref(arglist.v.list[2]);

	    free_var(arglist);
	    return make_raise_pack(E_INVIND, "Unknown hash algorithm", v);
	}
    } else
	algo = GCRY_MD_MD5;

    if (gcry_md_test_algo(algo)) {
	Var v = var_ref(arglist.v.list[2]);

	free_var(arglist);
	return make_raise_pack(E_INVIND, "Hash algorithm unavailable", v);
    }

    hash_size = gcry_md_get_algo_dlen(algo);
    hash = mymalloc(hash_size, M_STRING);
    gcry_md_hash_buffer(algo, hash, buf, buflen);
    free_var(arglist);

    hexdigest = mymalloc((hash_size * 2) + 1, M_STRING);
    for (i = 0; i < hash_size; ++i)
	sprintf(&hexdigest[i * 2], "%02x", (int) hash[i]);
    free_str(hash);

    r.type = TYPE_STR;
    r.v.str = str_dup(hexdigest);
    free_str(hexdigest);
    return make_var_pack(r);
}

static package
bf_binary_hash(Var arglist, Byte next, void *vdata, Objid progr)
{
    package rv;
    int length;
    const char *bytes = binary_to_raw_bytes(arglist.v.list[1].v.str, &length);

    if (!bytes) {
	free_var(arglist);
	return make_error_pack(E_INVARG);
    }
    return hash_bytes(arglist, bytes, length);
}

static package
bf_string_hash(Var arglist, Byte next, void *vdata, Objid progr)
{
    const char *str = arglist.v.list[1].v.str;

    return hash_bytes(arglist, str, memo_strlen(str));
}

extern package bf_value_hash(Var arglist, Byte next, void *, Objid progr);

void
register_gcrypt(void)
{
    const char *v;

    if (!(v = gcry_check_version(GCRYPT_VERSION))) {
	errlog("REGISTER_GCRYPT: libgcrypt version mismatch; no hashing for you!\n");
	return;
    }
    gcry_control(GCRYCTL_DISABLE_SECMEM, 0);
    gcry_control(GCRYCTL_INITIALIZATION_FINISHED, 0);

    register_function("binary_hash", 1, 2, bf_binary_hash, TYPE_STR, TYPE_STR);
    register_function("string_hash", 1, 2, bf_string_hash, TYPE_STR, TYPE_STR);
    register_function("value_hash", 1, 2, bf_value_hash, TYPE_ANY, TYPE_STR);

    oklog("REGISTER_GCRYPT: libgcrypt %s initialized\n", v);
}

#else /* MOO_GCRYPT */
void register_gcrypt(void) { }
#endif /* MOO_GCRYPT */
