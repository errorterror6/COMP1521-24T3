typedef struct _node Node;
struct _node {
    int value;      // offset 0
    Node *next;     // offset 4
};
//pointers are just addresses!!
//in the case of MIPS, they are 32 bits or 4 bytes long
//total size: 8


struct _enrolment {
    int stu_id;         // 0
    char course[9]:     // 4
    char term[5];       // 13 (4+9)
    char grade[3];      // 18
    double mark;        // 21
};