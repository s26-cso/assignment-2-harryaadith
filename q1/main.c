#include <stdio.h>
#include <stdlib.h>

// Define the struct to match the assembly layout
typedef struct Node {
    int val;
    // The compiler will naturally add 4 bytes of padding here 
    // to align the pointers to 8-byte boundaries.
    struct Node* left;
    struct Node* right;
} Node;

// Declare the external assembly functions
extern Node* make_node(int val);
extern Node* insert(Node* root, int val);
extern Node* get(Node* root, int val);
extern int getAtMost(int val, Node* root);

// Helper to print tree in-order to verify structure
void print_inorder(Node* root) {
    if (root == NULL) return;
    print_inorder(root->left);
    printf("%d ", root->val);
    print_inorder(root->right);
}

int main() {
    Node* root = NULL;

    printf("--- Testing Insert ---\n");
    // Note: your assembly insert returns the root
    root = insert(root, 50);
    root = insert(root, 30);
    root = insert(root, 70);
    root = insert(root, 20);
    root = insert(root, 40);
    
    printf("In-order traversal: ");
    print_inorder(root);
    printf("\n\n");

    printf("--- Testing Get ---\n");
    Node* found = get(root, 40);
    if (found) printf("Found node with value: %d\n", found->val);
    else printf("Value 40 not found!\n");

    Node* not_found = get(root, 99);
    if (not_found) printf("Found node with value: %d\n", not_found->val);
    else printf("Value 99 correctly not found.\n");
    printf("\n");

    printf("--- Testing getAtMost (Predecessor) ---\n");
    // Testing getAtMost(value, root)
    printf("At most 35: %d\n", getAtMost(35, root)); // Should be 30
    printf("At most 50: %d\n", getAtMost(50, root)); // Should be 50
    printf("At most 10: %d\n", getAtMost(10, root)); // Should be -1 (as per your code)

    return 0;
}
