#include "cisc225_c.h"

#include <Windows.h>
#include <chrono>
#include <cstdlib>
#include <ctime>
#include <string>
#include <thread>

HANDLE hStdin, hStdout;

static void stdinit() {
	static bool initialized = false;
	if (!initialized) {
		hStdin = GetStdHandle(STD_INPUT_HANDLE);
		hStdout = GetStdHandle(STD_OUTPUT_HANDLE);
		initialized = true;
	}
}

void c_delay(int ms) {
	stdinit();
	CONSOLE_CURSOR_INFO cci;
	GetConsoleCursorInfo(hStdout, &cci);
	cci.bVisible = FALSE;
	SetConsoleCursorInfo(hStdout, &cci);

	std::this_thread::sleep_for(std::chrono::milliseconds(ms));

	cci.bVisible = TRUE;
	SetConsoleCursorInfo(hStdout, &cci);
	FlushConsoleInputBuffer(hStdin);
}

void c_endprogram() {
	ExitProcess(0);
}

int c_getmaxxy() {
	stdinit();
	CONSOLE_SCREEN_BUFFER_INFO info;
	GetConsoleScreenBufferInfo(hStdout, &info);
	return info.srWindow.Bottom | (info.srWindow.Right << 16);
}

int c_gettextcolor() {
	stdinit();
	CONSOLE_SCREEN_BUFFER_INFO info;
	GetConsoleScreenBufferInfo(hStdout, &info);
	return info.wAttributes;
}

void c_gotoxy(int x, int y) {
	stdinit();
	COORD coord;
	coord.X = SHORT(x);
	coord.Y = SHORT(y);
	SetConsoleCursorPosition(hStdout, coord);
}

int c_random32() {
	return rand() * rand();
}

void c_randomize() {
	srand(time(0));
}

int c_readchar() {
	stdinit();
	INPUT_RECORD inrec;
	DWORD c_count;
	do {
		ReadConsoleInput(hStdin, &inrec, 1, &c_count);
	} while (!(inrec.EventType == KEY_EVENT && inrec.Event.KeyEvent.bKeyDown));
	return inrec.Event.KeyEvent.uChar.AsciiChar ?
		inrec.Event.KeyEvent.uChar.AsciiChar :
		inrec.Event.KeyEvent.wVirtualKeyCode << 8;
}

double c_readfloat() {
	char buf[80];
	c_readstring(buf, sizeof(buf));
	return atof(buf);
}

int c_readint() {
	char buf[80];
	c_readstring(buf, sizeof(buf));
	return atoi(buf);
}

size_t c_readstring(char *buf, size_t size) {
	stdinit();
	static char buf_r[1024];
	DWORD count;
	ReadFile(hStdin, buf_r, 1024, &count, NULL);
	buf_r[count -= 2] = 0;
	if (size > count)
		buf_r[count] = 0;
	strcpy_s(buf, size, buf_r);
	return count;
}

void c_settextcolor(int color) {
	stdinit();
	SetConsoleTextAttribute(hStdout, color);
}

void c_writechar(int ch) {
	static char buf[] = { 0, 0 };
	buf[0] = (char)ch;
	c_writestring(buf);
}

void c_writefloat(double f) {
	std::string str = std::to_string(f);
	c_writestring(str.c_str());
}

void c_writehex(int n) {
	static char hex[9] = { 0 };
	for (int i = 0; i < 8; i++) {
		char c = n & 0x0000000f;
		hex[7 - i] = c + (c < 10 ? '0' : 'A' - 10);
		n >>= 4;
	}
	c_writestring(hex);
}

void c_writeint(int n) {
	std::string str = std::to_string(n);
	c_writestring(str.c_str());
}

void c_writestring(const char *str) {
	stdinit();
	DWORD count;
	WriteFile(hStdout, str, strlen(str), &count, NULL);
}