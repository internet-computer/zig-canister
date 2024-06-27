#define IMPORT(m,n) __attribute__((import_module(m))) __attribute__((import_name(n)));
#define EXPORT(n) asm(n) __attribute__((visibility("default")))

void reply_append(void*, unsigned) IMPORT("ic0", "msg_reply_data_append");
void reply       (void)            IMPORT("ic0", "msg_reply");

void go() EXPORT("canister_query hi");

void go() {
  char msg[] = "Hello, World!\n";
  reply_append(msg, sizeof(msg) - 1);
  reply();
}
