// 20126507 hnyzx3 Zichen XU

// Can be compiled and executed with argument: gcc -std=c99 -lm -Wall -g airstrikeplanner.c -o airstrikeplanner && ./airstrikeplanner
// Tested with gcc 4.8.5 under CentOS 7.6.1810 (Core)

#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<ctype.h>
#include<stddef.h>
#include<math.h>
#include<errno.h>


#define NAME_MAX  255    // the max legnth of file name in Linux(CentOS) is 255 characters
#define DISP_X  50     // the width of display
#define DISP_Y  25     // the height of display


// Declaration for singly-linked list.
struct customizedStruct {
    char targetName[16];
    double targetLatitudeDouble;
    double targetLongitudeDouble;
    struct customizedStruct *next;
};
typedef struct customizedStruct ListNode;

// Function declaration
void moveNode(ListNode ** list1PtrPtr, ListNode * list1PrePtr, ListNode ** list2PrePtrPtr);
double distanceBetween(double predictLatitude, double predictLongitude, double targetLatitude, double targetLongitude);
void freeMem(ListNode *head);
int isConflict(ListNode *head, double targetLatitudeDouble, double targetLongitudeDouble);
int storeTarget(ListNode **tailPtrPtr, char * targetName, double targetLatitudeDouble, double targetLongitudeDouble);
int isValidTargetName(char * targetName);
int isValidTargetPositionDigits(char * targetPosition);
ListNode * loadFile(int * flag, ListNode * mainHEAD);
void printTargets(ListNode * printPtr);
ListNode * searchTarget(char * typeinName, ListNode * searchPtr);
void printMap(ListNode * head);


// move the node from list1 and add it to the tail of list2
// list1Ptr and list2PrePtr will be changed in this procedure
void moveNode(ListNode ** list1PtrPtr, ListNode * list1PrePtr, ListNode ** list2PrePtrPtr){

    list1PrePtr -> next = (*list1PtrPtr) -> next;       // get rid of the node which *list1PtrPtr points to in list1
    (*list2PrePtrPtr) -> next = (*list1PtrPtr);         // add this node to the tail of list2
    (*list1PtrPtr) -> next = NULL;
    (*list2PrePtrPtr) = (*list2PrePtrPtr) -> next;      // change * list2PrePtrPtr points to the new tail of list2
    (*list1PtrPtr) = list1PrePtr -> next;               // change * list1PtrPtr points to the next node in list1
}


// calculates the length of straight line segment between the two points
double distanceBetween(double predictLatitude, double predictLongitude, double targetLatitude, double targetLongitude){

    // distance = ((x1-x2)^2+(y1-y2)^2)^1/2
    double res = sqrt(pow(predictLatitude - targetLatitude, 2) + pow(predictLongitude - targetLongitude, 2));
    return res;
}


// to free memory of malloced linked-list starts by head

void freeMem(ListNode *head){

    // continually free the current struct and calls freeMen for the next struct
    if(head == NULL){
        return;
    } else {
    freeMem(head -> next);
    free(head);
    }
}


// return 1 if is conflict to previous targets, otherwise 0
// require traversal of the whole linked-list, O(n)
int isConflict(ListNode *head, double targetLatitudeDouble, double targetLongitudeDouble){

    while(head != NULL){
        // Two targets are considered as conflict if the distance between them is smaller than 0.1
        if(distanceBetween(head -> targetLatitudeDouble, head -> targetLongitudeDouble, targetLatitudeDouble, targetLongitudeDouble) < 0.1)
            return 1;
        head = head -> next;
    }
    return 0;
}


// stores the target as malloc linked-list node following tailPtr, and changed tailPtr to point at the tail
// return 1 if failed to malloc data
int storeTarget(ListNode **tailPtrPtr, char * targetName, double targetLatitudeDouble, double targetLongitudeDouble){

    ListNode * data = (ListNode*)malloc(sizeof(ListNode));
    if (data == NULL)
        return 1;
    data -> next = NULL;        // initialize the struct with target data
    strncpy(data -> targetName, targetName, strlen(targetName) * sizeof(char));
    data -> targetLongitudeDouble = targetLongitudeDouble;
    data -> targetLatitudeDouble = targetLatitudeDouble;
    
    (*tailPtrPtr) -> next = data;
    (*tailPtrPtr) = (*tailPtrPtr) -> next;      // reset * tailPtrPtr to point at the new linked-list tail
    return 0;
}


// return 0 if targetName contains English chars and digits only and within 15 chars, otherwise return 1
int isValidTargetName(char * targetName){

    if(strlen(targetName) > 15)     // The length of a name must be no more than 15 chars
        return 1;

    while(*targetName != '\0'){
        if(!isalnum(*targetName))       // Name is a string which contains English chars and digits only
            return 1;
        targetName++;
    }
    return 0;
}


// return 0 if targetPosition contains digits only (or with single '.') and within 15 chars, otherwise return 1
int isValidTargetPositionDigits(char * targetPosition){

    int dotCount = 0;
    // The length of a value must be no more than 15 digits including the decimal point '.'
    if(strlen(targetPosition) > 15 || (strlen(targetPosition) == 1 && *targetPosition == '.'))
        return 1;

    while(*targetPosition != '\0'){
        if(!(isdigit(*targetPosition)||*targetPosition == '.'))
            return 1;
        dotCount = *targetPosition == '.' ? dotCount + 1 : dotCount;
        targetPosition++;
    }
    // return 1 if has more than 1 dots in string
    if(dotCount > 1)
        return 1;

    return 0;
}


// returns a pointer to linked-list with data in target file, if file invalid return NULL
// input ListNode * mainHEAD to check whether contains conflict targets or not
// change flag to 0 if loaded unsuccessfully
ListNode * loadFile(int * flag, ListNode * mainHEAD){

    char fileName[NAME_MAX];
    printf("%s", "Enter a target file: ");
    fgets(fileName, NAME_MAX, stdin);

    if(fileName[strlen(fileName) - 1] == '\n')
        fileName[strlen(fileName) - 1] = '\0';  //get rid of the '\n' which <fgets> stores

    FILE *fp;
    char targetName[17];        // one more byte to detect whether overflow
    char targetLatitude[17];
    double targetLatitudeDouble = 0;
    char targetLongitude[17];
    double targetLongitudeDouble = 0;
    int lineLength = 1;

    // A valid target is in the format of "name value value"
    // this readSign will go 0, 1, 2 as circle to denote current position
    int readSign = 0;

    // Create a Dummy Head
    ListNode * HEAD = (ListNode*)malloc(sizeof(ListNode));
    HEAD -> next = NULL;
    strncpy(HEAD -> targetName, "DummyHEAD", sizeof("DummyHEAD"));
    HEAD -> targetLongitudeDouble = 0;
    HEAD -> targetLatitudeDouble = 0;

    ListNode * tailPtr = HEAD;

    if((fp = fopen(fileName, "r")) == NULL){        // file might not exist or might not have permission to read it
        perror("Error");        // print error message to stderr
        freeMem(HEAD);          // and free the memory used for linked-list starting from HEAD, which contains invalid target data
        return NULL;
    }
    int temp;
    // determine whether empty file or not
    fgetc(fp);

    if(feof(fp)){
        fclose(fp);
        *flag = 0;
        freeMem(HEAD);
        return NULL;
    }

    // calculate the buffer size needed for reading one line of data
    while(!feof(fp)){
        temp = fgetc(fp);
        if(temp == '\n'){
            fclose(fp);
            *flag = 0;
            freeMem(HEAD);
            return NULL;
        }
        lineLength++;
    }

    char lineData[lineLength+1];        // buffer to read in the line
    if(fseek(fp, 0, SEEK_SET) != 0){perror("Error");    // reset the file pointer to the beginning of file
        freeMem(HEAD);
        exit(-2);
    }

    // read in all data in the first line to lineData
    if(fgets(lineData, lineLength, fp) == NULL){         // file might contains not only one line
        fclose(fp);
        *flag = 0;
        freeMem(HEAD);
        return NULL;
    }

    if(fclose(fp))
    {
        perror("Error");
        freeMem(HEAD);
        exit(-2);
    }

    char * linePtr = lineData;
    // traversal of the whole line in buffer
    while(*linePtr != '\0'){
        // skip all spaces in the buffer
        if(*linePtr == ' '){
            linePtr++;
            continue;
        }
        if (readSign == 0){      // this denotes that it's time to read in targetName
            sscanf(linePtr, "%[^ ]", targetName);       //read into <targetName> until meets space

            if(isValidTargetName(targetName)){
                *flag = 0;
                freeMem(HEAD);
                return NULL;
        }
            linePtr += strlen(targetName);
            readSign = 1;       // add readSign by 1
            continue;
        }

        if (readSign == 1){      // this denotes that it's time to read in targetLatitude
            sscanf(linePtr, "%[^ ]", targetLatitude);       //read into <targetLatitude> until meets space

            if(isValidTargetPositionDigits(targetLatitude)){
                *flag = 0;
                freeMem(HEAD);
                return NULL;
            }

            // change the string which contains digits only (or with '.') to double
            targetLatitudeDouble = strtod(targetLatitude, NULL);
            if((targetLatitudeDouble < 0)||(targetLatitudeDouble > 100)){
                *flag = 0;
                freeMem(HEAD);
                return NULL;        // detect whether within the range of [0, 100]
            }

            linePtr += strlen(targetLatitude);
            readSign = 2;       // add readSign by 1
            continue;
        }

        if (readSign == 2){      // this denotes that it's time to read in targetLongitude
            sscanf(linePtr, "%[^ ]", targetLongitude);       //read into <targetLongitude> until meets space

            if(isValidTargetPositionDigits(targetLongitude)){
                *flag = 0;
                freeMem(HEAD);
                return NULL;
            }

            // change the string which contains digits only (or with '.') to double
            targetLongitudeDouble = strtod(targetLongitude, NULL);
            if((targetLongitudeDouble < 0)||(targetLongitudeDouble > 100)){
                *flag = 0;
                freeMem(HEAD);
                return NULL;        // detect whether within the range of [0, 100]
            }

            linePtr += strlen(targetLongitude);
            readSign = 0;       // reset readSign to 0

            // store the three data inside a struct into the linked-list
            // check whether conflict to the whole linked-list, abandon if so
            if(isConflict(HEAD -> next, targetLatitudeDouble, targetLongitudeDouble)||
               isConflict(mainHEAD -> next, targetLatitudeDouble, targetLongitudeDouble))
                continue;
            if(storeTarget(&tailPtr, targetName, targetLatitudeDouble, targetLongitudeDouble) == 1){
                    printf("%s", "Unable to allocate memory.");
                    freeMem(HEAD);
                    exit(-1);
                }
            continue;
        }
    }

    // the file must be invalid if does not end with readSign = 0
    if(readSign != 0){
        // fclose(fp);
        *flag = 0;
        freeMem(HEAD);
        return NULL;
    }

    ListNode * returnHEAD = HEAD -> next;
    free(HEAD); // free the Dummy Head
    return returnHEAD;
}


// print targets as "%s %lf %lf\n" format in linked-list starts form printPtr till end
// require traversal of the whole linked-list, O(n)
void printTargets(ListNode * printPtr){

    while(printPtr){
        printf("%s %lf %lf\n", printPtr -> targetName, printPtr -> targetLatitudeDouble, printPtr -> targetLongitudeDouble);
        printPtr = printPtr -> next;
    }
}


// search linked list whether "typreinName" exists, return the ListNode * if so, NULL otherwise
// require traversal of the whole linked-list, O(n)
ListNode * searchTarget(char * typeinName, ListNode * searchPtr){

    while(searchPtr){
        if(strcmp(typeinName, searchPtr -> targetName) == 0)
            return searchPtr;
        searchPtr = searchPtr -> next;
    }
    return NULL;
}


// print a map in DISP_Y * DISP_X, with hexadecimal numbers shown as target inside which area
void printMap(ListNode * head){

    char map[DISP_Y][DISP_X];
    memset(map, ':', sizeof(char) * DISP_Y * DISP_X);     // create a map with ':' as base

    int mapTargetLatitude = 0;
    int mapTargetLongitude = 0;
    int tempMapTargetLatitude = 0;
    int tempMapTargetLongitude = 0;

    while(head != NULL){
        // map the targets into a DISP_Y * DISP_X map
        tempMapTargetLatitude = (int)round((head -> targetLatitudeDouble) / (100 / DISP_X));
        tempMapTargetLongitude = (int)round((head -> targetLongitudeDouble) / (100 / DISP_Y));

        mapTargetLatitude = tempMapTargetLatitude == DISP_X ? tempMapTargetLatitude - 1 : tempMapTargetLatitude;
        mapTargetLongitude = tempMapTargetLongitude == DISP_Y ? tempMapTargetLongitude - 1 : tempMapTargetLongitude;
        // hexadecimal numbers representation of targets
        switch (map[mapTargetLongitude][mapTargetLatitude])
        {
        case ':':
            map[mapTargetLongitude][mapTargetLatitude] = '1';
            break;

        case '9':
            map[mapTargetLongitude][mapTargetLatitude] = 'A';
            break;

        default:
            map[mapTargetLongitude][mapTargetLatitude]++;
            break;
        }
        head = head -> next;
    }
    // display the DISP_Y * DISP_X map
    for(int height = 0; height < DISP_Y; height++){
        for(int width = 0; width < DISP_X; width++){
            printf("%c", map[height][width]);
        }
        if((height % 2) == 0)
            printf("    |- %d", 4 * height);
        else
            printf("    |    ");
        switch (height)
        {
        case 7:
            printf("\tL");
            break;

        case 8:
            printf("\tO");
            break;

        case 9:
            printf("\tN");
            break;

        case 10:
            printf("\tG\tEvery");
            break;

        case 11:
            printf("\tI\t  I");
            break;

        case 12:
            printf("\tT\t  =");
            break;

        case 13:
            printf("\tU\t  4");
            break;

        case 14:
            printf("\tD");
            break;

        case 15:
            printf("\tE");
            break;

        default:
            break;
        }
        putchar('\n');
    }
    putchar('\n');
    for(int width = 0; width < DISP_X; width++){
        printf("_");
    }
    putchar('\n');
    for(int width = 0; width < (DISP_X / 5) + 1; width++){
        printf("I    ");
    }
    putchar('\n');
    for(int width = 0; width < DISP_X + 1; width++){
        if(width == 0){
            printf("00");
            continue;
        }
        if((width % 5) == 0)
            printf("%d", 2 * width);
        else if((width % 5) != 1)
            printf(" ");
    }
    putchar('\n');
    putchar('\n');
    printf("                L A T I T U D D E                 ");
    putchar('\n');
    putchar('\n');
    printf("                   Every - = 2                    ");
    putchar('\n');
    printf(" Hexidecimal Representation of Targets within Area");
    putchar('\n');
    putchar('\n');
}


int main(int argc, char *argv[]){

    char menuInput[255];
    printf("%s", "1) Load a target file\n2) Show current targets\n3) Search a target\n4) Plan an airstrike\n5) Execute an airstrike\n6) Quit\n");
    ListNode * mainHEAD = (ListNode*)malloc(sizeof(ListNode));          // create a Dummy Head
    mainHEAD -> next = NULL;
    strncpy(mainHEAD -> targetName, "mainHEAD", sizeof("HEAD"));
    mainHEAD -> targetLongitudeDouble = 0;
    mainHEAD -> targetLatitudeDouble = 0;
    
    ListNode * tailPtr = mainHEAD;

    for( ; ; ){
        printf("%s", "Option: ");
        fgets(menuInput, 255, stdin);
        // rejecting input which is not one byte only
        if(menuInput[1] != '\n'){
            printf("%s", "Unknown option.\n");
            continue;
        }

        switch(menuInput[0])
        {
        // 1) Load a target file
        case '1':{
            int flag = 1;
            // <loadFile> returns a linked-list with data in target file inside
            // flag will be set by <loadFile> to 0 if the file is invalid
            ListNode * dataList = loadFile(&flag, mainHEAD);

            if(!flag){
                printf("%s", "Invalid file.\n");
                break;
            }

            tailPtr -> next = dataList;         // connect the data list to main list
            while(tailPtr -> next != NULL){
                tailPtr = tailPtr -> next;      // and set tailPtr always points to the last node of mainlist
            }

            break;
        }

        // 2) Show current targets
        case '2':{
            printTargets(mainHEAD -> next);
            printMap(mainHEAD -> next);

            break;
        }

        // 3) Search a target
        case '3':{
            printf("%s", "Enter the name: ");
            char typeinName[16];
            fgets(typeinName, 15, stdin);
            if(typeinName[0] == '\n')       // return to menu if the user presses return without entering any other characters
                break;

            if(typeinName[strlen(typeinName) - 1] == '\n')
                typeinName[strlen(typeinName) - 1] = '\0';  //get rid of the '\n' which <fgets> stores

            // existPtr points to the found target, otherwise NULL
            ListNode * searchListPtr = mainHEAD -> next;
            ListNode * existPtr = NULL;
            // while loop is for handling multiple targets with the same name
            while(searchListPtr){
                existPtr = searchTarget(typeinName, searchListPtr);
                if(existPtr == NULL){
                    printf("%s", "Entry does not exist.\n");
                    break;
                } else {
                    printf("%s %lf %lf\n", existPtr -> targetName, existPtr -> targetLatitudeDouble, existPtr -> targetLongitudeDouble);
                    searchListPtr = existPtr -> next;
                }
            }
        break;
        }

        // 4) Plan an airstrike
        case '4':{
            double predictLatitude = 0;
            double predictLongitude = 0;
            double predictRatio = 0;
            printf("%s", "Enter predicted latitude: ");
            scanf("%lf", &predictLatitude);
            while(getchar() != '\n');
            if(predictLatitude < 0 || predictLatitude > 100){
                printf("%s", "Latitude should be within the range of [0, 100].\n");
                break;
            }
            printf("%s", "Enter predicted longitude: ");
            scanf("%lf", &predictLongitude);
            while(getchar() != '\n');
            if(predictLongitude < 0 || predictLongitude > 100){
                printf("%s", "Longitude should be within the range of [0, 100].\n");
                break;
            }
            printf("%s", "Enter ratio of damage zone: ");
            scanf("%lf", &predictRatio);
            if(predictRatio <= 0){
                printf("%s", "Radius should be positive number.\n");
                break;
            }
            while(getchar() != '\n');

            ListNode * planPtr = mainHEAD -> next;
            // traversal of the whole list, print targets within planned airstrike range
            while(planPtr){

                if(distanceBetween(predictLatitude, predictLongitude, planPtr -> targetLatitudeDouble, planPtr -> targetLongitudeDouble) <= predictRatio){
                printf("%s %lf %lf\n", planPtr -> targetName, planPtr -> targetLatitudeDouble, planPtr -> targetLongitudeDouble);
                }
                planPtr = planPtr -> next;
            }
        break;
        }

        // 5) Execute an airstrike
        case '5':{
            double actionLatitude = 0;
            double actionLongitude = 0;
            double actionRatio = 0;
            printf("%s", "Enter target latitude: ");
            scanf("%lf", &actionLatitude);
            if(actionLatitude < 0 || actionLatitude > 100){
                printf("%s", "Latitude should be within the range of [0, 100].\n");
                break;
            }
            while(getchar() != '\n');
            printf("%s", "Enter target longitude: ");
            scanf("%lf", &actionLongitude);
            if(actionLongitude < 0 || actionLongitude > 100){
                printf("%s", "Longitude should be within the range of [0, 100].\n");
                break;
            }
            while(getchar() != '\n');
            printf("%s", "Enter radius of damage zone: ");
            scanf("%lf", &actionRatio);
            if(actionRatio <= 0){
                printf("%s", "Radius should be positive number.\n");
                break;
            }
            while(getchar() != '\n');

            ListNode * actionPtr = mainHEAD -> next;
            ListNode * actionPrePtr = mainHEAD;
            int destroy = 0;        // count of the total distoried targets

            // yet another Dummy Head...
            ListNode * destroyHEAD = (ListNode*)malloc(sizeof(ListNode));
            destroyHEAD -> next = NULL;
            destroyHEAD -> targetLatitudeDouble = 0;
            destroyHEAD -> targetLongitudeDouble = 0;
            strncpy(destroyHEAD -> targetName, "destroyHEAD", strlen("destroyHEAD") * sizeof(char));
            ListNode * destroyPre = destroyHEAD;

            while(actionPtr){

                if(distanceBetween(actionLatitude, actionLongitude, actionPtr -> targetLatitudeDouble, actionPtr -> targetLongitudeDouble) <= actionRatio){

                    destroy++;
                    // move the node within range from mainlist to destroylist, in order to print the distoried ones
                    moveNode(&actionPtr, actionPrePtr, &destroyPre);

                } else {
                actionPrePtr = actionPrePtr -> next;
                actionPtr = actionPtr -> next;
                }
            }
            if(destroy == 0){
                printf("%s", "No target aimed. Mission cancelled.\n");
                freeMem(destroyHEAD);
            } else {
                printf("%d target destroyed.\n", destroy);
                printTargets(destroyHEAD -> next);
                freeMem(destroyHEAD);
            }
        break;
        }

        // 6) Quit
        case '6':{
            // free used memory by linked-list
            freeMem(mainHEAD);
            return 0;
        break;
        }

        default:
            printf("%s", "Unknown option.\n");
        break;
        }
    }
    return 0;
}