
kernel: formato do arquivo elf32-i386


Desmontagem da seção .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:
8010000c:	0f 20 e0             	mov    %cr4,%eax
8010000f:	83 c8 10             	or     $0x10,%eax
80100012:	0f 22 e0             	mov    %eax,%cr4
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
8010001a:	0f 22 d8             	mov    %eax,%cr3
8010001d:	0f 20 c0             	mov    %cr0,%eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
80100025:	0f 22 c0             	mov    %eax,%cr0
80100028:	bc 50 c6 10 80       	mov    $0x8010c650,%esp
8010002d:	b8 8f 38 10 80       	mov    $0x8010388f,%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003a:	83 ec 08             	sub    $0x8,%esp
8010003d:	68 74 86 10 80       	push   $0x80108674
80100042:	68 60 c6 10 80       	push   $0x8010c660
80100047:	e8 c7 50 00 00       	call   80105113 <initlock>
8010004c:	83 c4 10             	add    $0x10,%esp

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004f:	c7 05 70 05 11 80 64 	movl   $0x80110564,0x80110570
80100056:	05 11 80 
  bcache.head.next = &bcache.head;
80100059:	c7 05 74 05 11 80 64 	movl   $0x80110564,0x80110574
80100060:	05 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100063:	c7 45 f4 94 c6 10 80 	movl   $0x8010c694,-0xc(%ebp)
8010006a:	eb 3a                	jmp    801000a6 <binit+0x72>
    b->next = bcache.head.next;
8010006c:	8b 15 74 05 11 80    	mov    0x80110574,%edx
80100072:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100075:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bcache.head;
80100078:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007b:	c7 40 0c 64 05 11 80 	movl   $0x80110564,0xc(%eax)
    b->dev = -1;
80100082:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100085:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
8010008c:	a1 74 05 11 80       	mov    0x80110574,%eax
80100091:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100094:	89 50 0c             	mov    %edx,0xc(%eax)
    bcache.head.next = b;
80100097:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010009a:	a3 74 05 11 80       	mov    %eax,0x80110574
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009f:	81 45 f4 18 02 00 00 	addl   $0x218,-0xc(%ebp)
801000a6:	b8 64 05 11 80       	mov    $0x80110564,%eax
801000ab:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801000ae:	72 bc                	jb     8010006c <binit+0x38>
  }
}
801000b0:	90                   	nop
801000b1:	c9                   	leave  
801000b2:	c3                   	ret    

801000b3 <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return B_BUSY buffer.
static struct buf*
bget(uint dev, uint blockno)
{
801000b3:	55                   	push   %ebp
801000b4:	89 e5                	mov    %esp,%ebp
801000b6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000b9:	83 ec 0c             	sub    $0xc,%esp
801000bc:	68 60 c6 10 80       	push   $0x8010c660
801000c1:	e8 6f 50 00 00       	call   80105135 <acquire>
801000c6:	83 c4 10             	add    $0x10,%esp

 loop:
  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000c9:	a1 74 05 11 80       	mov    0x80110574,%eax
801000ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000d1:	eb 67                	jmp    8010013a <bget+0x87>
    if(b->dev == dev && b->blockno == blockno){
801000d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000d6:	8b 40 04             	mov    0x4(%eax),%eax
801000d9:	3b 45 08             	cmp    0x8(%ebp),%eax
801000dc:	75 53                	jne    80100131 <bget+0x7e>
801000de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000e1:	8b 40 08             	mov    0x8(%eax),%eax
801000e4:	3b 45 0c             	cmp    0xc(%ebp),%eax
801000e7:	75 48                	jne    80100131 <bget+0x7e>
      if(!(b->flags & B_BUSY)){
801000e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000ec:	8b 00                	mov    (%eax),%eax
801000ee:	83 e0 01             	and    $0x1,%eax
801000f1:	85 c0                	test   %eax,%eax
801000f3:	75 27                	jne    8010011c <bget+0x69>
        b->flags |= B_BUSY;
801000f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000f8:	8b 00                	mov    (%eax),%eax
801000fa:	83 c8 01             	or     $0x1,%eax
801000fd:	89 c2                	mov    %eax,%edx
801000ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100102:	89 10                	mov    %edx,(%eax)
        release(&bcache.lock);
80100104:	83 ec 0c             	sub    $0xc,%esp
80100107:	68 60 c6 10 80       	push   $0x8010c660
8010010c:	e8 8b 50 00 00       	call   8010519c <release>
80100111:	83 c4 10             	add    $0x10,%esp
        return b;
80100114:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100117:	e9 98 00 00 00       	jmp    801001b4 <bget+0x101>
      }
      sleep(b, &bcache.lock);
8010011c:	83 ec 08             	sub    $0x8,%esp
8010011f:	68 60 c6 10 80       	push   $0x8010c660
80100124:	ff 75 f4             	pushl  -0xc(%ebp)
80100127:	e8 1e 4d 00 00       	call   80104e4a <sleep>
8010012c:	83 c4 10             	add    $0x10,%esp
      goto loop;
8010012f:	eb 98                	jmp    801000c9 <bget+0x16>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
80100131:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100134:	8b 40 10             	mov    0x10(%eax),%eax
80100137:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010013a:	81 7d f4 64 05 11 80 	cmpl   $0x80110564,-0xc(%ebp)
80100141:	75 90                	jne    801000d3 <bget+0x20>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100143:	a1 70 05 11 80       	mov    0x80110570,%eax
80100148:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010014b:	eb 51                	jmp    8010019e <bget+0xeb>
    if((b->flags & B_BUSY) == 0 && (b->flags & B_DIRTY) == 0){
8010014d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100150:	8b 00                	mov    (%eax),%eax
80100152:	83 e0 01             	and    $0x1,%eax
80100155:	85 c0                	test   %eax,%eax
80100157:	75 3c                	jne    80100195 <bget+0xe2>
80100159:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010015c:	8b 00                	mov    (%eax),%eax
8010015e:	83 e0 04             	and    $0x4,%eax
80100161:	85 c0                	test   %eax,%eax
80100163:	75 30                	jne    80100195 <bget+0xe2>
      b->dev = dev;
80100165:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100168:	8b 55 08             	mov    0x8(%ebp),%edx
8010016b:	89 50 04             	mov    %edx,0x4(%eax)
      b->blockno = blockno;
8010016e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100171:	8b 55 0c             	mov    0xc(%ebp),%edx
80100174:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = B_BUSY;
80100177:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010017a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
      release(&bcache.lock);
80100180:	83 ec 0c             	sub    $0xc,%esp
80100183:	68 60 c6 10 80       	push   $0x8010c660
80100188:	e8 0f 50 00 00       	call   8010519c <release>
8010018d:	83 c4 10             	add    $0x10,%esp
      return b;
80100190:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100193:	eb 1f                	jmp    801001b4 <bget+0x101>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100195:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100198:	8b 40 0c             	mov    0xc(%eax),%eax
8010019b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010019e:	81 7d f4 64 05 11 80 	cmpl   $0x80110564,-0xc(%ebp)
801001a5:	75 a6                	jne    8010014d <bget+0x9a>
    }
  }
  panic("bget: no buffers");
801001a7:	83 ec 0c             	sub    $0xc,%esp
801001aa:	68 7b 86 10 80       	push   $0x8010867b
801001af:	e8 b2 03 00 00       	call   80100566 <panic>
}
801001b4:	c9                   	leave  
801001b5:	c3                   	ret    

801001b6 <bread>:

// Return a B_BUSY buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801001b6:	55                   	push   %ebp
801001b7:	89 e5                	mov    %esp,%ebp
801001b9:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  b = bget(dev, blockno);
801001bc:	83 ec 08             	sub    $0x8,%esp
801001bf:	ff 75 0c             	pushl  0xc(%ebp)
801001c2:	ff 75 08             	pushl  0x8(%ebp)
801001c5:	e8 e9 fe ff ff       	call   801000b3 <bget>
801001ca:	83 c4 10             	add    $0x10,%esp
801001cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!(b->flags & B_VALID)) {
801001d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001d3:	8b 00                	mov    (%eax),%eax
801001d5:	83 e0 02             	and    $0x2,%eax
801001d8:	85 c0                	test   %eax,%eax
801001da:	75 0e                	jne    801001ea <bread+0x34>
    iderw(b);
801001dc:	83 ec 0c             	sub    $0xc,%esp
801001df:	ff 75 f4             	pushl  -0xc(%ebp)
801001e2:	e8 26 27 00 00       	call   8010290d <iderw>
801001e7:	83 c4 10             	add    $0x10,%esp
  }
  return b;
801001ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801001ed:	c9                   	leave  
801001ee:	c3                   	ret    

801001ef <bwrite>:

// Write b's contents to disk.  Must be B_BUSY.
void
bwrite(struct buf *b)
{
801001ef:	55                   	push   %ebp
801001f0:	89 e5                	mov    %esp,%ebp
801001f2:	83 ec 08             	sub    $0x8,%esp
  if((b->flags & B_BUSY) == 0)
801001f5:	8b 45 08             	mov    0x8(%ebp),%eax
801001f8:	8b 00                	mov    (%eax),%eax
801001fa:	83 e0 01             	and    $0x1,%eax
801001fd:	85 c0                	test   %eax,%eax
801001ff:	75 0d                	jne    8010020e <bwrite+0x1f>
    panic("bwrite");
80100201:	83 ec 0c             	sub    $0xc,%esp
80100204:	68 8c 86 10 80       	push   $0x8010868c
80100209:	e8 58 03 00 00       	call   80100566 <panic>
  b->flags |= B_DIRTY;
8010020e:	8b 45 08             	mov    0x8(%ebp),%eax
80100211:	8b 00                	mov    (%eax),%eax
80100213:	83 c8 04             	or     $0x4,%eax
80100216:	89 c2                	mov    %eax,%edx
80100218:	8b 45 08             	mov    0x8(%ebp),%eax
8010021b:	89 10                	mov    %edx,(%eax)
  iderw(b);
8010021d:	83 ec 0c             	sub    $0xc,%esp
80100220:	ff 75 08             	pushl  0x8(%ebp)
80100223:	e8 e5 26 00 00       	call   8010290d <iderw>
80100228:	83 c4 10             	add    $0x10,%esp
}
8010022b:	90                   	nop
8010022c:	c9                   	leave  
8010022d:	c3                   	ret    

8010022e <brelse>:

// Release a B_BUSY buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
8010022e:	55                   	push   %ebp
8010022f:	89 e5                	mov    %esp,%ebp
80100231:	83 ec 08             	sub    $0x8,%esp
  if((b->flags & B_BUSY) == 0)
80100234:	8b 45 08             	mov    0x8(%ebp),%eax
80100237:	8b 00                	mov    (%eax),%eax
80100239:	83 e0 01             	and    $0x1,%eax
8010023c:	85 c0                	test   %eax,%eax
8010023e:	75 0d                	jne    8010024d <brelse+0x1f>
    panic("brelse");
80100240:	83 ec 0c             	sub    $0xc,%esp
80100243:	68 93 86 10 80       	push   $0x80108693
80100248:	e8 19 03 00 00       	call   80100566 <panic>

  acquire(&bcache.lock);
8010024d:	83 ec 0c             	sub    $0xc,%esp
80100250:	68 60 c6 10 80       	push   $0x8010c660
80100255:	e8 db 4e 00 00       	call   80105135 <acquire>
8010025a:	83 c4 10             	add    $0x10,%esp

  b->next->prev = b->prev;
8010025d:	8b 45 08             	mov    0x8(%ebp),%eax
80100260:	8b 40 10             	mov    0x10(%eax),%eax
80100263:	8b 55 08             	mov    0x8(%ebp),%edx
80100266:	8b 52 0c             	mov    0xc(%edx),%edx
80100269:	89 50 0c             	mov    %edx,0xc(%eax)
  b->prev->next = b->next;
8010026c:	8b 45 08             	mov    0x8(%ebp),%eax
8010026f:	8b 40 0c             	mov    0xc(%eax),%eax
80100272:	8b 55 08             	mov    0x8(%ebp),%edx
80100275:	8b 52 10             	mov    0x10(%edx),%edx
80100278:	89 50 10             	mov    %edx,0x10(%eax)
  b->next = bcache.head.next;
8010027b:	8b 15 74 05 11 80    	mov    0x80110574,%edx
80100281:	8b 45 08             	mov    0x8(%ebp),%eax
80100284:	89 50 10             	mov    %edx,0x10(%eax)
  b->prev = &bcache.head;
80100287:	8b 45 08             	mov    0x8(%ebp),%eax
8010028a:	c7 40 0c 64 05 11 80 	movl   $0x80110564,0xc(%eax)
  bcache.head.next->prev = b;
80100291:	a1 74 05 11 80       	mov    0x80110574,%eax
80100296:	8b 55 08             	mov    0x8(%ebp),%edx
80100299:	89 50 0c             	mov    %edx,0xc(%eax)
  bcache.head.next = b;
8010029c:	8b 45 08             	mov    0x8(%ebp),%eax
8010029f:	a3 74 05 11 80       	mov    %eax,0x80110574

  b->flags &= ~B_BUSY;
801002a4:	8b 45 08             	mov    0x8(%ebp),%eax
801002a7:	8b 00                	mov    (%eax),%eax
801002a9:	83 e0 fe             	and    $0xfffffffe,%eax
801002ac:	89 c2                	mov    %eax,%edx
801002ae:	8b 45 08             	mov    0x8(%ebp),%eax
801002b1:	89 10                	mov    %edx,(%eax)
  wakeup(b);
801002b3:	83 ec 0c             	sub    $0xc,%esp
801002b6:	ff 75 08             	pushl  0x8(%ebp)
801002b9:	e8 77 4c 00 00       	call   80104f35 <wakeup>
801002be:	83 c4 10             	add    $0x10,%esp

  release(&bcache.lock);
801002c1:	83 ec 0c             	sub    $0xc,%esp
801002c4:	68 60 c6 10 80       	push   $0x8010c660
801002c9:	e8 ce 4e 00 00       	call   8010519c <release>
801002ce:	83 c4 10             	add    $0x10,%esp
}
801002d1:	90                   	nop
801002d2:	c9                   	leave  
801002d3:	c3                   	ret    

801002d4 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801002d4:	55                   	push   %ebp
801002d5:	89 e5                	mov    %esp,%ebp
801002d7:	83 ec 14             	sub    $0x14,%esp
801002da:	8b 45 08             	mov    0x8(%ebp),%eax
801002dd:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801002e1:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801002e5:	89 c2                	mov    %eax,%edx
801002e7:	ec                   	in     (%dx),%al
801002e8:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801002eb:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801002ef:	c9                   	leave  
801002f0:	c3                   	ret    

801002f1 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801002f1:	55                   	push   %ebp
801002f2:	89 e5                	mov    %esp,%ebp
801002f4:	83 ec 08             	sub    $0x8,%esp
801002f7:	8b 55 08             	mov    0x8(%ebp),%edx
801002fa:	8b 45 0c             	mov    0xc(%ebp),%eax
801002fd:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80100301:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100304:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80100308:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010030c:	ee                   	out    %al,(%dx)
}
8010030d:	90                   	nop
8010030e:	c9                   	leave  
8010030f:	c3                   	ret    

80100310 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80100310:	55                   	push   %ebp
80100311:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80100313:	fa                   	cli    
}
80100314:	90                   	nop
80100315:	5d                   	pop    %ebp
80100316:	c3                   	ret    

80100317 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100317:	55                   	push   %ebp
80100318:	89 e5                	mov    %esp,%ebp
8010031a:	53                   	push   %ebx
8010031b:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
8010031e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100322:	74 1c                	je     80100340 <printint+0x29>
80100324:	8b 45 08             	mov    0x8(%ebp),%eax
80100327:	c1 e8 1f             	shr    $0x1f,%eax
8010032a:	0f b6 c0             	movzbl %al,%eax
8010032d:	89 45 10             	mov    %eax,0x10(%ebp)
80100330:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100334:	74 0a                	je     80100340 <printint+0x29>
    x = -xx;
80100336:	8b 45 08             	mov    0x8(%ebp),%eax
80100339:	f7 d8                	neg    %eax
8010033b:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010033e:	eb 06                	jmp    80100346 <printint+0x2f>
  else
    x = xx;
80100340:	8b 45 08             	mov    0x8(%ebp),%eax
80100343:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
80100346:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
8010034d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100350:	8d 41 01             	lea    0x1(%ecx),%eax
80100353:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100356:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80100359:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010035c:	ba 00 00 00 00       	mov    $0x0,%edx
80100361:	f7 f3                	div    %ebx
80100363:	89 d0                	mov    %edx,%eax
80100365:	0f b6 80 04 90 10 80 	movzbl -0x7fef6ffc(%eax),%eax
8010036c:	88 44 0d e0          	mov    %al,-0x20(%ebp,%ecx,1)
  }while((x /= base) != 0);
80100370:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80100373:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100376:	ba 00 00 00 00       	mov    $0x0,%edx
8010037b:	f7 f3                	div    %ebx
8010037d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100380:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100384:	75 c7                	jne    8010034d <printint+0x36>

  if(sign)
80100386:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010038a:	74 2a                	je     801003b6 <printint+0x9f>
    buf[i++] = '-';
8010038c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010038f:	8d 50 01             	lea    0x1(%eax),%edx
80100392:	89 55 f4             	mov    %edx,-0xc(%ebp)
80100395:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)

  while(--i >= 0)
8010039a:	eb 1a                	jmp    801003b6 <printint+0x9f>
    consputc(buf[i]);
8010039c:	8d 55 e0             	lea    -0x20(%ebp),%edx
8010039f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801003a2:	01 d0                	add    %edx,%eax
801003a4:	0f b6 00             	movzbl (%eax),%eax
801003a7:	0f be c0             	movsbl %al,%eax
801003aa:	83 ec 0c             	sub    $0xc,%esp
801003ad:	50                   	push   %eax
801003ae:	e8 df 03 00 00       	call   80100792 <consputc>
801003b3:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
801003b6:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
801003ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801003be:	79 dc                	jns    8010039c <printint+0x85>
}
801003c0:	90                   	nop
801003c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801003c4:	c9                   	leave  
801003c5:	c3                   	ret    

801003c6 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
801003c6:	55                   	push   %ebp
801003c7:	89 e5                	mov    %esp,%ebp
801003c9:	83 ec 28             	sub    $0x28,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
801003cc:	a1 f4 b5 10 80       	mov    0x8010b5f4,%eax
801003d1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
801003d4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801003d8:	74 10                	je     801003ea <cprintf+0x24>
    acquire(&cons.lock);
801003da:	83 ec 0c             	sub    $0xc,%esp
801003dd:	68 c0 b5 10 80       	push   $0x8010b5c0
801003e2:	e8 4e 4d 00 00       	call   80105135 <acquire>
801003e7:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
801003ea:	8b 45 08             	mov    0x8(%ebp),%eax
801003ed:	85 c0                	test   %eax,%eax
801003ef:	75 0d                	jne    801003fe <cprintf+0x38>
    panic("null fmt");
801003f1:	83 ec 0c             	sub    $0xc,%esp
801003f4:	68 9a 86 10 80       	push   $0x8010869a
801003f9:	e8 68 01 00 00       	call   80100566 <panic>

  argp = (uint*)(void*)(&fmt + 1);
801003fe:	8d 45 0c             	lea    0xc(%ebp),%eax
80100401:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100404:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010040b:	e9 1a 01 00 00       	jmp    8010052a <cprintf+0x164>
    if(c != '%'){
80100410:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
80100414:	74 13                	je     80100429 <cprintf+0x63>
      consputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	ff 75 e4             	pushl  -0x1c(%ebp)
8010041c:	e8 71 03 00 00       	call   80100792 <consputc>
80100421:	83 c4 10             	add    $0x10,%esp
      continue;
80100424:	e9 fd 00 00 00       	jmp    80100526 <cprintf+0x160>
    }
    c = fmt[++i] & 0xff;
80100429:	8b 55 08             	mov    0x8(%ebp),%edx
8010042c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100430:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100433:	01 d0                	add    %edx,%eax
80100435:	0f b6 00             	movzbl (%eax),%eax
80100438:	0f be c0             	movsbl %al,%eax
8010043b:	25 ff 00 00 00       	and    $0xff,%eax
80100440:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
80100443:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100447:	0f 84 ff 00 00 00    	je     8010054c <cprintf+0x186>
      break;
    switch(c){
8010044d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100450:	83 f8 70             	cmp    $0x70,%eax
80100453:	74 47                	je     8010049c <cprintf+0xd6>
80100455:	83 f8 70             	cmp    $0x70,%eax
80100458:	7f 13                	jg     8010046d <cprintf+0xa7>
8010045a:	83 f8 25             	cmp    $0x25,%eax
8010045d:	0f 84 98 00 00 00    	je     801004fb <cprintf+0x135>
80100463:	83 f8 64             	cmp    $0x64,%eax
80100466:	74 14                	je     8010047c <cprintf+0xb6>
80100468:	e9 9d 00 00 00       	jmp    8010050a <cprintf+0x144>
8010046d:	83 f8 73             	cmp    $0x73,%eax
80100470:	74 47                	je     801004b9 <cprintf+0xf3>
80100472:	83 f8 78             	cmp    $0x78,%eax
80100475:	74 25                	je     8010049c <cprintf+0xd6>
80100477:	e9 8e 00 00 00       	jmp    8010050a <cprintf+0x144>
    case 'd':
      printint(*argp++, 10, 1);
8010047c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010047f:	8d 50 04             	lea    0x4(%eax),%edx
80100482:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100485:	8b 00                	mov    (%eax),%eax
80100487:	83 ec 04             	sub    $0x4,%esp
8010048a:	6a 01                	push   $0x1
8010048c:	6a 0a                	push   $0xa
8010048e:	50                   	push   %eax
8010048f:	e8 83 fe ff ff       	call   80100317 <printint>
80100494:	83 c4 10             	add    $0x10,%esp
      break;
80100497:	e9 8a 00 00 00       	jmp    80100526 <cprintf+0x160>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
8010049c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010049f:	8d 50 04             	lea    0x4(%eax),%edx
801004a2:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004a5:	8b 00                	mov    (%eax),%eax
801004a7:	83 ec 04             	sub    $0x4,%esp
801004aa:	6a 00                	push   $0x0
801004ac:	6a 10                	push   $0x10
801004ae:	50                   	push   %eax
801004af:	e8 63 fe ff ff       	call   80100317 <printint>
801004b4:	83 c4 10             	add    $0x10,%esp
      break;
801004b7:	eb 6d                	jmp    80100526 <cprintf+0x160>
    case 's':
      if((s = (char*)*argp++) == 0)
801004b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004bc:	8d 50 04             	lea    0x4(%eax),%edx
801004bf:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004c2:	8b 00                	mov    (%eax),%eax
801004c4:	89 45 ec             	mov    %eax,-0x14(%ebp)
801004c7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801004cb:	75 22                	jne    801004ef <cprintf+0x129>
        s = "(null)";
801004cd:	c7 45 ec a3 86 10 80 	movl   $0x801086a3,-0x14(%ebp)
      for(; *s; s++)
801004d4:	eb 19                	jmp    801004ef <cprintf+0x129>
        consputc(*s);
801004d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004d9:	0f b6 00             	movzbl (%eax),%eax
801004dc:	0f be c0             	movsbl %al,%eax
801004df:	83 ec 0c             	sub    $0xc,%esp
801004e2:	50                   	push   %eax
801004e3:	e8 aa 02 00 00       	call   80100792 <consputc>
801004e8:	83 c4 10             	add    $0x10,%esp
      for(; *s; s++)
801004eb:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801004ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004f2:	0f b6 00             	movzbl (%eax),%eax
801004f5:	84 c0                	test   %al,%al
801004f7:	75 dd                	jne    801004d6 <cprintf+0x110>
      break;
801004f9:	eb 2b                	jmp    80100526 <cprintf+0x160>
    case '%':
      consputc('%');
801004fb:	83 ec 0c             	sub    $0xc,%esp
801004fe:	6a 25                	push   $0x25
80100500:	e8 8d 02 00 00       	call   80100792 <consputc>
80100505:	83 c4 10             	add    $0x10,%esp
      break;
80100508:	eb 1c                	jmp    80100526 <cprintf+0x160>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
8010050a:	83 ec 0c             	sub    $0xc,%esp
8010050d:	6a 25                	push   $0x25
8010050f:	e8 7e 02 00 00       	call   80100792 <consputc>
80100514:	83 c4 10             	add    $0x10,%esp
      consputc(c);
80100517:	83 ec 0c             	sub    $0xc,%esp
8010051a:	ff 75 e4             	pushl  -0x1c(%ebp)
8010051d:	e8 70 02 00 00       	call   80100792 <consputc>
80100522:	83 c4 10             	add    $0x10,%esp
      break;
80100525:	90                   	nop
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100526:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010052a:	8b 55 08             	mov    0x8(%ebp),%edx
8010052d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100530:	01 d0                	add    %edx,%eax
80100532:	0f b6 00             	movzbl (%eax),%eax
80100535:	0f be c0             	movsbl %al,%eax
80100538:	25 ff 00 00 00       	and    $0xff,%eax
8010053d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100540:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100544:	0f 85 c6 fe ff ff    	jne    80100410 <cprintf+0x4a>
8010054a:	eb 01                	jmp    8010054d <cprintf+0x187>
      break;
8010054c:	90                   	nop
    }
  }

  if(locking)
8010054d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100551:	74 10                	je     80100563 <cprintf+0x19d>
    release(&cons.lock);
80100553:	83 ec 0c             	sub    $0xc,%esp
80100556:	68 c0 b5 10 80       	push   $0x8010b5c0
8010055b:	e8 3c 4c 00 00       	call   8010519c <release>
80100560:	83 c4 10             	add    $0x10,%esp
}
80100563:	90                   	nop
80100564:	c9                   	leave  
80100565:	c3                   	ret    

80100566 <panic>:

void
panic(char *s)
{
80100566:	55                   	push   %ebp
80100567:	89 e5                	mov    %esp,%ebp
80100569:	83 ec 38             	sub    $0x38,%esp
  int i;
  uint pcs[10];
  
  cli();
8010056c:	e8 9f fd ff ff       	call   80100310 <cli>
  cons.locking = 0;
80100571:	c7 05 f4 b5 10 80 00 	movl   $0x0,0x8010b5f4
80100578:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
8010057b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80100581:	0f b6 00             	movzbl (%eax),%eax
80100584:	0f b6 c0             	movzbl %al,%eax
80100587:	83 ec 08             	sub    $0x8,%esp
8010058a:	50                   	push   %eax
8010058b:	68 aa 86 10 80       	push   $0x801086aa
80100590:	e8 31 fe ff ff       	call   801003c6 <cprintf>
80100595:	83 c4 10             	add    $0x10,%esp
  cprintf(s);
80100598:	8b 45 08             	mov    0x8(%ebp),%eax
8010059b:	83 ec 0c             	sub    $0xc,%esp
8010059e:	50                   	push   %eax
8010059f:	e8 22 fe ff ff       	call   801003c6 <cprintf>
801005a4:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
801005a7:	83 ec 0c             	sub    $0xc,%esp
801005aa:	68 b9 86 10 80       	push   $0x801086b9
801005af:	e8 12 fe ff ff       	call   801003c6 <cprintf>
801005b4:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
801005b7:	83 ec 08             	sub    $0x8,%esp
801005ba:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005bd:	50                   	push   %eax
801005be:	8d 45 08             	lea    0x8(%ebp),%eax
801005c1:	50                   	push   %eax
801005c2:	e8 27 4c 00 00       	call   801051ee <getcallerpcs>
801005c7:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
801005ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801005d1:	eb 1c                	jmp    801005ef <panic+0x89>
    cprintf(" %p", pcs[i]);
801005d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005d6:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005da:	83 ec 08             	sub    $0x8,%esp
801005dd:	50                   	push   %eax
801005de:	68 bb 86 10 80       	push   $0x801086bb
801005e3:	e8 de fd ff ff       	call   801003c6 <cprintf>
801005e8:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
801005eb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801005ef:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801005f3:	7e de                	jle    801005d3 <panic+0x6d>
  panicked = 1; // freeze other CPU
801005f5:	c7 05 a0 b5 10 80 01 	movl   $0x1,0x8010b5a0
801005fc:	00 00 00 
  for(;;)
801005ff:	eb fe                	jmp    801005ff <panic+0x99>

80100601 <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
80100601:	55                   	push   %ebp
80100602:	89 e5                	mov    %esp,%ebp
80100604:	83 ec 18             	sub    $0x18,%esp
  int pos;
  
  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
80100607:	6a 0e                	push   $0xe
80100609:	68 d4 03 00 00       	push   $0x3d4
8010060e:	e8 de fc ff ff       	call   801002f1 <outb>
80100613:	83 c4 08             	add    $0x8,%esp
  pos = inb(CRTPORT+1) << 8;
80100616:	68 d5 03 00 00       	push   $0x3d5
8010061b:	e8 b4 fc ff ff       	call   801002d4 <inb>
80100620:	83 c4 04             	add    $0x4,%esp
80100623:	0f b6 c0             	movzbl %al,%eax
80100626:	c1 e0 08             	shl    $0x8,%eax
80100629:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
8010062c:	6a 0f                	push   $0xf
8010062e:	68 d4 03 00 00       	push   $0x3d4
80100633:	e8 b9 fc ff ff       	call   801002f1 <outb>
80100638:	83 c4 08             	add    $0x8,%esp
  pos |= inb(CRTPORT+1);
8010063b:	68 d5 03 00 00       	push   $0x3d5
80100640:	e8 8f fc ff ff       	call   801002d4 <inb>
80100645:	83 c4 04             	add    $0x4,%esp
80100648:	0f b6 c0             	movzbl %al,%eax
8010064b:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
8010064e:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
80100652:	75 30                	jne    80100684 <cgaputc+0x83>
    pos += 80 - pos%80;
80100654:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100657:	ba 67 66 66 66       	mov    $0x66666667,%edx
8010065c:	89 c8                	mov    %ecx,%eax
8010065e:	f7 ea                	imul   %edx
80100660:	c1 fa 05             	sar    $0x5,%edx
80100663:	89 c8                	mov    %ecx,%eax
80100665:	c1 f8 1f             	sar    $0x1f,%eax
80100668:	29 c2                	sub    %eax,%edx
8010066a:	89 d0                	mov    %edx,%eax
8010066c:	c1 e0 02             	shl    $0x2,%eax
8010066f:	01 d0                	add    %edx,%eax
80100671:	c1 e0 04             	shl    $0x4,%eax
80100674:	29 c1                	sub    %eax,%ecx
80100676:	89 ca                	mov    %ecx,%edx
80100678:	b8 50 00 00 00       	mov    $0x50,%eax
8010067d:	29 d0                	sub    %edx,%eax
8010067f:	01 45 f4             	add    %eax,-0xc(%ebp)
80100682:	eb 34                	jmp    801006b8 <cgaputc+0xb7>
  else if(c == BACKSPACE){
80100684:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
8010068b:	75 0c                	jne    80100699 <cgaputc+0x98>
    if(pos > 0) --pos;
8010068d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100691:	7e 25                	jle    801006b8 <cgaputc+0xb7>
80100693:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
80100697:	eb 1f                	jmp    801006b8 <cgaputc+0xb7>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100699:	8b 0d 00 90 10 80    	mov    0x80109000,%ecx
8010069f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801006a2:	8d 50 01             	lea    0x1(%eax),%edx
801006a5:	89 55 f4             	mov    %edx,-0xc(%ebp)
801006a8:	01 c0                	add    %eax,%eax
801006aa:	01 c8                	add    %ecx,%eax
801006ac:	8b 55 08             	mov    0x8(%ebp),%edx
801006af:	0f b6 d2             	movzbl %dl,%edx
801006b2:	80 ce 07             	or     $0x7,%dh
801006b5:	66 89 10             	mov    %dx,(%eax)

  if(pos < 0 || pos > 25*80)
801006b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801006bc:	78 09                	js     801006c7 <cgaputc+0xc6>
801006be:	81 7d f4 d0 07 00 00 	cmpl   $0x7d0,-0xc(%ebp)
801006c5:	7e 0d                	jle    801006d4 <cgaputc+0xd3>
    panic("pos under/overflow");
801006c7:	83 ec 0c             	sub    $0xc,%esp
801006ca:	68 bf 86 10 80       	push   $0x801086bf
801006cf:	e8 92 fe ff ff       	call   80100566 <panic>
  
  if((pos/80) >= 24){  // Scroll up.
801006d4:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
801006db:	7e 4c                	jle    80100729 <cgaputc+0x128>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801006dd:	a1 00 90 10 80       	mov    0x80109000,%eax
801006e2:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
801006e8:	a1 00 90 10 80       	mov    0x80109000,%eax
801006ed:	83 ec 04             	sub    $0x4,%esp
801006f0:	68 60 0e 00 00       	push   $0xe60
801006f5:	52                   	push   %edx
801006f6:	50                   	push   %eax
801006f7:	e8 5b 4d 00 00       	call   80105457 <memmove>
801006fc:	83 c4 10             	add    $0x10,%esp
    pos -= 80;
801006ff:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100703:	b8 80 07 00 00       	mov    $0x780,%eax
80100708:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010070b:	8d 14 00             	lea    (%eax,%eax,1),%edx
8010070e:	a1 00 90 10 80       	mov    0x80109000,%eax
80100713:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100716:	01 c9                	add    %ecx,%ecx
80100718:	01 c8                	add    %ecx,%eax
8010071a:	83 ec 04             	sub    $0x4,%esp
8010071d:	52                   	push   %edx
8010071e:	6a 00                	push   $0x0
80100720:	50                   	push   %eax
80100721:	e8 72 4c 00 00       	call   80105398 <memset>
80100726:	83 c4 10             	add    $0x10,%esp
  }
  
  outb(CRTPORT, 14);
80100729:	83 ec 08             	sub    $0x8,%esp
8010072c:	6a 0e                	push   $0xe
8010072e:	68 d4 03 00 00       	push   $0x3d4
80100733:	e8 b9 fb ff ff       	call   801002f1 <outb>
80100738:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos>>8);
8010073b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010073e:	c1 f8 08             	sar    $0x8,%eax
80100741:	0f b6 c0             	movzbl %al,%eax
80100744:	83 ec 08             	sub    $0x8,%esp
80100747:	50                   	push   %eax
80100748:	68 d5 03 00 00       	push   $0x3d5
8010074d:	e8 9f fb ff ff       	call   801002f1 <outb>
80100752:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT, 15);
80100755:	83 ec 08             	sub    $0x8,%esp
80100758:	6a 0f                	push   $0xf
8010075a:	68 d4 03 00 00       	push   $0x3d4
8010075f:	e8 8d fb ff ff       	call   801002f1 <outb>
80100764:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos);
80100767:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010076a:	0f b6 c0             	movzbl %al,%eax
8010076d:	83 ec 08             	sub    $0x8,%esp
80100770:	50                   	push   %eax
80100771:	68 d5 03 00 00       	push   $0x3d5
80100776:	e8 76 fb ff ff       	call   801002f1 <outb>
8010077b:	83 c4 10             	add    $0x10,%esp
  crt[pos] = ' ' | 0x0700;
8010077e:	a1 00 90 10 80       	mov    0x80109000,%eax
80100783:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100786:	01 d2                	add    %edx,%edx
80100788:	01 d0                	add    %edx,%eax
8010078a:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
8010078f:	90                   	nop
80100790:	c9                   	leave  
80100791:	c3                   	ret    

80100792 <consputc>:

void
consputc(int c)
{
80100792:	55                   	push   %ebp
80100793:	89 e5                	mov    %esp,%ebp
80100795:	83 ec 08             	sub    $0x8,%esp
  if(panicked){
80100798:	a1 a0 b5 10 80       	mov    0x8010b5a0,%eax
8010079d:	85 c0                	test   %eax,%eax
8010079f:	74 07                	je     801007a8 <consputc+0x16>
    cli();
801007a1:	e8 6a fb ff ff       	call   80100310 <cli>
    for(;;)
801007a6:	eb fe                	jmp    801007a6 <consputc+0x14>
      ;
  }

  if(c == BACKSPACE){
801007a8:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
801007af:	75 29                	jne    801007da <consputc+0x48>
    uartputc('\b'); uartputc(' '); uartputc('\b');
801007b1:	83 ec 0c             	sub    $0xc,%esp
801007b4:	6a 08                	push   $0x8
801007b6:	e8 42 65 00 00       	call   80106cfd <uartputc>
801007bb:	83 c4 10             	add    $0x10,%esp
801007be:	83 ec 0c             	sub    $0xc,%esp
801007c1:	6a 20                	push   $0x20
801007c3:	e8 35 65 00 00       	call   80106cfd <uartputc>
801007c8:	83 c4 10             	add    $0x10,%esp
801007cb:	83 ec 0c             	sub    $0xc,%esp
801007ce:	6a 08                	push   $0x8
801007d0:	e8 28 65 00 00       	call   80106cfd <uartputc>
801007d5:	83 c4 10             	add    $0x10,%esp
801007d8:	eb 0e                	jmp    801007e8 <consputc+0x56>
  } else
    uartputc(c);
801007da:	83 ec 0c             	sub    $0xc,%esp
801007dd:	ff 75 08             	pushl  0x8(%ebp)
801007e0:	e8 18 65 00 00       	call   80106cfd <uartputc>
801007e5:	83 c4 10             	add    $0x10,%esp
  cgaputc(c);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	ff 75 08             	pushl  0x8(%ebp)
801007ee:	e8 0e fe ff ff       	call   80100601 <cgaputc>
801007f3:	83 c4 10             	add    $0x10,%esp
}
801007f6:	90                   	nop
801007f7:	c9                   	leave  
801007f8:	c3                   	ret    

801007f9 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007f9:	55                   	push   %ebp
801007fa:	89 e5                	mov    %esp,%ebp
801007fc:	83 ec 18             	sub    $0x18,%esp
  int c, doprocdump = 0;
801007ff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&cons.lock);
80100806:	83 ec 0c             	sub    $0xc,%esp
80100809:	68 c0 b5 10 80       	push   $0x8010b5c0
8010080e:	e8 22 49 00 00       	call   80105135 <acquire>
80100813:	83 c4 10             	add    $0x10,%esp
  while((c = getc()) >= 0){
80100816:	e9 44 01 00 00       	jmp    8010095f <consoleintr+0x166>
    switch(c){
8010081b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010081e:	83 f8 10             	cmp    $0x10,%eax
80100821:	74 1e                	je     80100841 <consoleintr+0x48>
80100823:	83 f8 10             	cmp    $0x10,%eax
80100826:	7f 0a                	jg     80100832 <consoleintr+0x39>
80100828:	83 f8 08             	cmp    $0x8,%eax
8010082b:	74 6b                	je     80100898 <consoleintr+0x9f>
8010082d:	e9 9b 00 00 00       	jmp    801008cd <consoleintr+0xd4>
80100832:	83 f8 15             	cmp    $0x15,%eax
80100835:	74 33                	je     8010086a <consoleintr+0x71>
80100837:	83 f8 7f             	cmp    $0x7f,%eax
8010083a:	74 5c                	je     80100898 <consoleintr+0x9f>
8010083c:	e9 8c 00 00 00       	jmp    801008cd <consoleintr+0xd4>
    case C('P'):  // Process listing.
      doprocdump = 1;   // procdump() locks cons.lock indirectly; invoke later
80100841:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
      break;
80100848:	e9 12 01 00 00       	jmp    8010095f <consoleintr+0x166>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
8010084d:	a1 08 08 11 80       	mov    0x80110808,%eax
80100852:	83 e8 01             	sub    $0x1,%eax
80100855:	a3 08 08 11 80       	mov    %eax,0x80110808
        consputc(BACKSPACE);
8010085a:	83 ec 0c             	sub    $0xc,%esp
8010085d:	68 00 01 00 00       	push   $0x100
80100862:	e8 2b ff ff ff       	call   80100792 <consputc>
80100867:	83 c4 10             	add    $0x10,%esp
      while(input.e != input.w &&
8010086a:	8b 15 08 08 11 80    	mov    0x80110808,%edx
80100870:	a1 04 08 11 80       	mov    0x80110804,%eax
80100875:	39 c2                	cmp    %eax,%edx
80100877:	0f 84 e2 00 00 00    	je     8010095f <consoleintr+0x166>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
8010087d:	a1 08 08 11 80       	mov    0x80110808,%eax
80100882:	83 e8 01             	sub    $0x1,%eax
80100885:	83 e0 7f             	and    $0x7f,%eax
80100888:	0f b6 80 80 07 11 80 	movzbl -0x7feef880(%eax),%eax
      while(input.e != input.w &&
8010088f:	3c 0a                	cmp    $0xa,%al
80100891:	75 ba                	jne    8010084d <consoleintr+0x54>
      }
      break;
80100893:	e9 c7 00 00 00       	jmp    8010095f <consoleintr+0x166>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
80100898:	8b 15 08 08 11 80    	mov    0x80110808,%edx
8010089e:	a1 04 08 11 80       	mov    0x80110804,%eax
801008a3:	39 c2                	cmp    %eax,%edx
801008a5:	0f 84 b4 00 00 00    	je     8010095f <consoleintr+0x166>
        input.e--;
801008ab:	a1 08 08 11 80       	mov    0x80110808,%eax
801008b0:	83 e8 01             	sub    $0x1,%eax
801008b3:	a3 08 08 11 80       	mov    %eax,0x80110808
        consputc(BACKSPACE);
801008b8:	83 ec 0c             	sub    $0xc,%esp
801008bb:	68 00 01 00 00       	push   $0x100
801008c0:	e8 cd fe ff ff       	call   80100792 <consputc>
801008c5:	83 c4 10             	add    $0x10,%esp
      }
      break;
801008c8:	e9 92 00 00 00       	jmp    8010095f <consoleintr+0x166>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008cd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801008d1:	0f 84 87 00 00 00    	je     8010095e <consoleintr+0x165>
801008d7:	8b 15 08 08 11 80    	mov    0x80110808,%edx
801008dd:	a1 00 08 11 80       	mov    0x80110800,%eax
801008e2:	29 c2                	sub    %eax,%edx
801008e4:	89 d0                	mov    %edx,%eax
801008e6:	83 f8 7f             	cmp    $0x7f,%eax
801008e9:	77 73                	ja     8010095e <consoleintr+0x165>
        c = (c == '\r') ? '\n' : c;
801008eb:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
801008ef:	74 05                	je     801008f6 <consoleintr+0xfd>
801008f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801008f4:	eb 05                	jmp    801008fb <consoleintr+0x102>
801008f6:	b8 0a 00 00 00       	mov    $0xa,%eax
801008fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
801008fe:	a1 08 08 11 80       	mov    0x80110808,%eax
80100903:	8d 50 01             	lea    0x1(%eax),%edx
80100906:	89 15 08 08 11 80    	mov    %edx,0x80110808
8010090c:	83 e0 7f             	and    $0x7f,%eax
8010090f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100912:	88 90 80 07 11 80    	mov    %dl,-0x7feef880(%eax)
        consputc(c);
80100918:	83 ec 0c             	sub    $0xc,%esp
8010091b:	ff 75 f0             	pushl  -0x10(%ebp)
8010091e:	e8 6f fe ff ff       	call   80100792 <consputc>
80100923:	83 c4 10             	add    $0x10,%esp
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100926:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
8010092a:	74 18                	je     80100944 <consoleintr+0x14b>
8010092c:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100930:	74 12                	je     80100944 <consoleintr+0x14b>
80100932:	a1 08 08 11 80       	mov    0x80110808,%eax
80100937:	8b 15 00 08 11 80    	mov    0x80110800,%edx
8010093d:	83 ea 80             	sub    $0xffffff80,%edx
80100940:	39 d0                	cmp    %edx,%eax
80100942:	75 1a                	jne    8010095e <consoleintr+0x165>
          input.w = input.e;
80100944:	a1 08 08 11 80       	mov    0x80110808,%eax
80100949:	a3 04 08 11 80       	mov    %eax,0x80110804
          wakeup(&input.r);
8010094e:	83 ec 0c             	sub    $0xc,%esp
80100951:	68 00 08 11 80       	push   $0x80110800
80100956:	e8 da 45 00 00       	call   80104f35 <wakeup>
8010095b:	83 c4 10             	add    $0x10,%esp
        }
      }
      break;
8010095e:	90                   	nop
  while((c = getc()) >= 0){
8010095f:	8b 45 08             	mov    0x8(%ebp),%eax
80100962:	ff d0                	call   *%eax
80100964:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100967:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010096b:	0f 89 aa fe ff ff    	jns    8010081b <consoleintr+0x22>
    }
  }
  release(&cons.lock);
80100971:	83 ec 0c             	sub    $0xc,%esp
80100974:	68 c0 b5 10 80       	push   $0x8010b5c0
80100979:	e8 1e 48 00 00       	call   8010519c <release>
8010097e:	83 c4 10             	add    $0x10,%esp
  if(doprocdump) {
80100981:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100985:	74 05                	je     8010098c <consoleintr+0x193>
    procdump();  // now call procdump() wo. cons.lock held
80100987:	e8 64 46 00 00       	call   80104ff0 <procdump>
  }
}
8010098c:	90                   	nop
8010098d:	c9                   	leave  
8010098e:	c3                   	ret    

8010098f <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
8010098f:	55                   	push   %ebp
80100990:	89 e5                	mov    %esp,%ebp
80100992:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
80100995:	83 ec 0c             	sub    $0xc,%esp
80100998:	ff 75 08             	pushl  0x8(%ebp)
8010099b:	e8 28 11 00 00       	call   80101ac8 <iunlock>
801009a0:	83 c4 10             	add    $0x10,%esp
  target = n;
801009a3:	8b 45 10             	mov    0x10(%ebp),%eax
801009a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&cons.lock);
801009a9:	83 ec 0c             	sub    $0xc,%esp
801009ac:	68 c0 b5 10 80       	push   $0x8010b5c0
801009b1:	e8 7f 47 00 00       	call   80105135 <acquire>
801009b6:	83 c4 10             	add    $0x10,%esp
  while(n > 0){
801009b9:	e9 ac 00 00 00       	jmp    80100a6a <consoleread+0xdb>
    while(input.r == input.w){
      if(proc->killed){
801009be:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801009c4:	8b 40 24             	mov    0x24(%eax),%eax
801009c7:	85 c0                	test   %eax,%eax
801009c9:	74 28                	je     801009f3 <consoleread+0x64>
        release(&cons.lock);
801009cb:	83 ec 0c             	sub    $0xc,%esp
801009ce:	68 c0 b5 10 80       	push   $0x8010b5c0
801009d3:	e8 c4 47 00 00       	call   8010519c <release>
801009d8:	83 c4 10             	add    $0x10,%esp
        ilock(ip);
801009db:	83 ec 0c             	sub    $0xc,%esp
801009de:	ff 75 08             	pushl  0x8(%ebp)
801009e1:	e8 84 0f 00 00       	call   8010196a <ilock>
801009e6:	83 c4 10             	add    $0x10,%esp
        return -1;
801009e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801009ee:	e9 ab 00 00 00       	jmp    80100a9e <consoleread+0x10f>
      }
      sleep(&input.r, &cons.lock);
801009f3:	83 ec 08             	sub    $0x8,%esp
801009f6:	68 c0 b5 10 80       	push   $0x8010b5c0
801009fb:	68 00 08 11 80       	push   $0x80110800
80100a00:	e8 45 44 00 00       	call   80104e4a <sleep>
80100a05:	83 c4 10             	add    $0x10,%esp
    while(input.r == input.w){
80100a08:	8b 15 00 08 11 80    	mov    0x80110800,%edx
80100a0e:	a1 04 08 11 80       	mov    0x80110804,%eax
80100a13:	39 c2                	cmp    %eax,%edx
80100a15:	74 a7                	je     801009be <consoleread+0x2f>
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100a17:	a1 00 08 11 80       	mov    0x80110800,%eax
80100a1c:	8d 50 01             	lea    0x1(%eax),%edx
80100a1f:	89 15 00 08 11 80    	mov    %edx,0x80110800
80100a25:	83 e0 7f             	and    $0x7f,%eax
80100a28:	0f b6 80 80 07 11 80 	movzbl -0x7feef880(%eax),%eax
80100a2f:	0f be c0             	movsbl %al,%eax
80100a32:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(c == C('D')){  // EOF
80100a35:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100a39:	75 17                	jne    80100a52 <consoleread+0xc3>
      if(n < target){
80100a3b:	8b 45 10             	mov    0x10(%ebp),%eax
80100a3e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80100a41:	73 2f                	jae    80100a72 <consoleread+0xe3>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100a43:	a1 00 08 11 80       	mov    0x80110800,%eax
80100a48:	83 e8 01             	sub    $0x1,%eax
80100a4b:	a3 00 08 11 80       	mov    %eax,0x80110800
      }
      break;
80100a50:	eb 20                	jmp    80100a72 <consoleread+0xe3>
    }
    *dst++ = c;
80100a52:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a55:	8d 50 01             	lea    0x1(%eax),%edx
80100a58:	89 55 0c             	mov    %edx,0xc(%ebp)
80100a5b:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100a5e:	88 10                	mov    %dl,(%eax)
    --n;
80100a60:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    if(c == '\n')
80100a64:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100a68:	74 0b                	je     80100a75 <consoleread+0xe6>
  while(n > 0){
80100a6a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100a6e:	7f 98                	jg     80100a08 <consoleread+0x79>
80100a70:	eb 04                	jmp    80100a76 <consoleread+0xe7>
      break;
80100a72:	90                   	nop
80100a73:	eb 01                	jmp    80100a76 <consoleread+0xe7>
      break;
80100a75:	90                   	nop
  }
  release(&cons.lock);
80100a76:	83 ec 0c             	sub    $0xc,%esp
80100a79:	68 c0 b5 10 80       	push   $0x8010b5c0
80100a7e:	e8 19 47 00 00       	call   8010519c <release>
80100a83:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100a86:	83 ec 0c             	sub    $0xc,%esp
80100a89:	ff 75 08             	pushl  0x8(%ebp)
80100a8c:	e8 d9 0e 00 00       	call   8010196a <ilock>
80100a91:	83 c4 10             	add    $0x10,%esp

  return target - n;
80100a94:	8b 45 10             	mov    0x10(%ebp),%eax
80100a97:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100a9a:	29 c2                	sub    %eax,%edx
80100a9c:	89 d0                	mov    %edx,%eax
}
80100a9e:	c9                   	leave  
80100a9f:	c3                   	ret    

80100aa0 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100aa0:	55                   	push   %ebp
80100aa1:	89 e5                	mov    %esp,%ebp
80100aa3:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100aa6:	83 ec 0c             	sub    $0xc,%esp
80100aa9:	ff 75 08             	pushl  0x8(%ebp)
80100aac:	e8 17 10 00 00       	call   80101ac8 <iunlock>
80100ab1:	83 c4 10             	add    $0x10,%esp
  acquire(&cons.lock);
80100ab4:	83 ec 0c             	sub    $0xc,%esp
80100ab7:	68 c0 b5 10 80       	push   $0x8010b5c0
80100abc:	e8 74 46 00 00       	call   80105135 <acquire>
80100ac1:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++)
80100ac4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100acb:	eb 21                	jmp    80100aee <consolewrite+0x4e>
    consputc(buf[i] & 0xff);
80100acd:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100ad0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ad3:	01 d0                	add    %edx,%eax
80100ad5:	0f b6 00             	movzbl (%eax),%eax
80100ad8:	0f be c0             	movsbl %al,%eax
80100adb:	0f b6 c0             	movzbl %al,%eax
80100ade:	83 ec 0c             	sub    $0xc,%esp
80100ae1:	50                   	push   %eax
80100ae2:	e8 ab fc ff ff       	call   80100792 <consputc>
80100ae7:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++)
80100aea:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100aee:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100af1:	3b 45 10             	cmp    0x10(%ebp),%eax
80100af4:	7c d7                	jl     80100acd <consolewrite+0x2d>
  release(&cons.lock);
80100af6:	83 ec 0c             	sub    $0xc,%esp
80100af9:	68 c0 b5 10 80       	push   $0x8010b5c0
80100afe:	e8 99 46 00 00       	call   8010519c <release>
80100b03:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100b06:	83 ec 0c             	sub    $0xc,%esp
80100b09:	ff 75 08             	pushl  0x8(%ebp)
80100b0c:	e8 59 0e 00 00       	call   8010196a <ilock>
80100b11:	83 c4 10             	add    $0x10,%esp

  return n;
80100b14:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100b17:	c9                   	leave  
80100b18:	c3                   	ret    

80100b19 <consoleinit>:

void
consoleinit(void)
{
80100b19:	55                   	push   %ebp
80100b1a:	89 e5                	mov    %esp,%ebp
80100b1c:	83 ec 08             	sub    $0x8,%esp
  initlock(&cons.lock, "console");
80100b1f:	83 ec 08             	sub    $0x8,%esp
80100b22:	68 d2 86 10 80       	push   $0x801086d2
80100b27:	68 c0 b5 10 80       	push   $0x8010b5c0
80100b2c:	e8 e2 45 00 00       	call   80105113 <initlock>
80100b31:	83 c4 10             	add    $0x10,%esp

  devsw[CONSOLE].write = consolewrite;
80100b34:	c7 05 cc 11 11 80 a0 	movl   $0x80100aa0,0x801111cc
80100b3b:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100b3e:	c7 05 c8 11 11 80 8f 	movl   $0x8010098f,0x801111c8
80100b45:	09 10 80 
  cons.locking = 1;
80100b48:	c7 05 f4 b5 10 80 01 	movl   $0x1,0x8010b5f4
80100b4f:	00 00 00 

  picenable(IRQ_KBD);
80100b52:	83 ec 0c             	sub    $0xc,%esp
80100b55:	6a 01                	push   $0x1
80100b57:	e8 cf 33 00 00       	call   80103f2b <picenable>
80100b5c:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_KBD, 0);
80100b5f:	83 ec 08             	sub    $0x8,%esp
80100b62:	6a 00                	push   $0x0
80100b64:	6a 01                	push   $0x1
80100b66:	e8 6f 1f 00 00       	call   80102ada <ioapicenable>
80100b6b:	83 c4 10             	add    $0x10,%esp
}
80100b6e:	90                   	nop
80100b6f:	c9                   	leave  
80100b70:	c3                   	ret    

80100b71 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100b71:	55                   	push   %ebp
80100b72:	89 e5                	mov    %esp,%ebp
80100b74:	81 ec 18 01 00 00    	sub    $0x118,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  begin_op();
80100b7a:	e8 ce 29 00 00       	call   8010354d <begin_op>
  if((ip = namei(path)) == 0){
80100b7f:	83 ec 0c             	sub    $0xc,%esp
80100b82:	ff 75 08             	pushl  0x8(%ebp)
80100b85:	e8 9e 19 00 00       	call   80102528 <namei>
80100b8a:	83 c4 10             	add    $0x10,%esp
80100b8d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100b90:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100b94:	75 0f                	jne    80100ba5 <exec+0x34>
    end_op();
80100b96:	e8 3e 2a 00 00       	call   801035d9 <end_op>
    return -1;
80100b9b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100ba0:	e9 ce 03 00 00       	jmp    80100f73 <exec+0x402>
  }
  ilock(ip);
80100ba5:	83 ec 0c             	sub    $0xc,%esp
80100ba8:	ff 75 d8             	pushl  -0x28(%ebp)
80100bab:	e8 ba 0d 00 00       	call   8010196a <ilock>
80100bb0:	83 c4 10             	add    $0x10,%esp
  pgdir = 0;
80100bb3:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
80100bba:	6a 34                	push   $0x34
80100bbc:	6a 00                	push   $0x0
80100bbe:	8d 85 0c ff ff ff    	lea    -0xf4(%ebp),%eax
80100bc4:	50                   	push   %eax
80100bc5:	ff 75 d8             	pushl  -0x28(%ebp)
80100bc8:	e8 0b 13 00 00       	call   80101ed8 <readi>
80100bcd:	83 c4 10             	add    $0x10,%esp
80100bd0:	83 f8 33             	cmp    $0x33,%eax
80100bd3:	0f 86 49 03 00 00    	jbe    80100f22 <exec+0x3b1>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100bd9:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100bdf:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100be4:	0f 85 3b 03 00 00    	jne    80100f25 <exec+0x3b4>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100bea:	e8 63 72 00 00       	call   80107e52 <setupkvm>
80100bef:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100bf2:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100bf6:	0f 84 2c 03 00 00    	je     80100f28 <exec+0x3b7>
    goto bad;

  // Load program into memory.
  sz = 0;
80100bfc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c03:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100c0a:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
80100c10:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100c13:	e9 ab 00 00 00       	jmp    80100cc3 <exec+0x152>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100c18:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100c1b:	6a 20                	push   $0x20
80100c1d:	50                   	push   %eax
80100c1e:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
80100c24:	50                   	push   %eax
80100c25:	ff 75 d8             	pushl  -0x28(%ebp)
80100c28:	e8 ab 12 00 00       	call   80101ed8 <readi>
80100c2d:	83 c4 10             	add    $0x10,%esp
80100c30:	83 f8 20             	cmp    $0x20,%eax
80100c33:	0f 85 f2 02 00 00    	jne    80100f2b <exec+0x3ba>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100c39:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100c3f:	83 f8 01             	cmp    $0x1,%eax
80100c42:	75 71                	jne    80100cb5 <exec+0x144>
      continue;
    if(ph.memsz < ph.filesz)
80100c44:	8b 95 00 ff ff ff    	mov    -0x100(%ebp),%edx
80100c4a:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100c50:	39 c2                	cmp    %eax,%edx
80100c52:	0f 82 d6 02 00 00    	jb     80100f2e <exec+0x3bd>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100c58:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
80100c5e:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
80100c64:	01 d0                	add    %edx,%eax
80100c66:	83 ec 04             	sub    $0x4,%esp
80100c69:	50                   	push   %eax
80100c6a:	ff 75 e0             	pushl  -0x20(%ebp)
80100c6d:	ff 75 d4             	pushl  -0x2c(%ebp)
80100c70:	e8 84 75 00 00       	call   801081f9 <allocuvm>
80100c75:	83 c4 10             	add    $0x10,%esp
80100c78:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100c7b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100c7f:	0f 84 ac 02 00 00    	je     80100f31 <exec+0x3c0>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100c85:	8b 95 fc fe ff ff    	mov    -0x104(%ebp),%edx
80100c8b:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c91:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
80100c97:	83 ec 0c             	sub    $0xc,%esp
80100c9a:	52                   	push   %edx
80100c9b:	50                   	push   %eax
80100c9c:	ff 75 d8             	pushl  -0x28(%ebp)
80100c9f:	51                   	push   %ecx
80100ca0:	ff 75 d4             	pushl  -0x2c(%ebp)
80100ca3:	e8 7a 74 00 00       	call   80108122 <loaduvm>
80100ca8:	83 c4 20             	add    $0x20,%esp
80100cab:	85 c0                	test   %eax,%eax
80100cad:	0f 88 81 02 00 00    	js     80100f34 <exec+0x3c3>
80100cb3:	eb 01                	jmp    80100cb6 <exec+0x145>
      continue;
80100cb5:	90                   	nop
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100cb6:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100cba:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100cbd:	83 c0 20             	add    $0x20,%eax
80100cc0:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100cc3:	0f b7 85 38 ff ff ff 	movzwl -0xc8(%ebp),%eax
80100cca:	0f b7 c0             	movzwl %ax,%eax
80100ccd:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80100cd0:	0f 8f 42 ff ff ff    	jg     80100c18 <exec+0xa7>
      goto bad;
  }
  iunlockput(ip);
80100cd6:	83 ec 0c             	sub    $0xc,%esp
80100cd9:	ff 75 d8             	pushl  -0x28(%ebp)
80100cdc:	e8 49 0f 00 00       	call   80101c2a <iunlockput>
80100ce1:	83 c4 10             	add    $0x10,%esp
  end_op();
80100ce4:	e8 f0 28 00 00       	call   801035d9 <end_op>
  ip = 0;
80100ce9:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100cf0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cf3:	05 ff 0f 00 00       	add    $0xfff,%eax
80100cf8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100cfd:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100d00:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d03:	05 00 20 00 00       	add    $0x2000,%eax
80100d08:	83 ec 04             	sub    $0x4,%esp
80100d0b:	50                   	push   %eax
80100d0c:	ff 75 e0             	pushl  -0x20(%ebp)
80100d0f:	ff 75 d4             	pushl  -0x2c(%ebp)
80100d12:	e8 e2 74 00 00       	call   801081f9 <allocuvm>
80100d17:	83 c4 10             	add    $0x10,%esp
80100d1a:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100d1d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100d21:	0f 84 10 02 00 00    	je     80100f37 <exec+0x3c6>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100d27:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d2a:	2d 00 20 00 00       	sub    $0x2000,%eax
80100d2f:	83 ec 08             	sub    $0x8,%esp
80100d32:	50                   	push   %eax
80100d33:	ff 75 d4             	pushl  -0x2c(%ebp)
80100d36:	e8 e4 76 00 00       	call   8010841f <clearpteu>
80100d3b:	83 c4 10             	add    $0x10,%esp
  sp = sz;
80100d3e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d41:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d44:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100d4b:	e9 96 00 00 00       	jmp    80100de6 <exec+0x275>
    if(argc >= MAXARG)
80100d50:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100d54:	0f 87 e0 01 00 00    	ja     80100f3a <exec+0x3c9>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d5a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d5d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d64:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d67:	01 d0                	add    %edx,%eax
80100d69:	8b 00                	mov    (%eax),%eax
80100d6b:	83 ec 0c             	sub    $0xc,%esp
80100d6e:	50                   	push   %eax
80100d6f:	e8 71 48 00 00       	call   801055e5 <strlen>
80100d74:	83 c4 10             	add    $0x10,%esp
80100d77:	89 c2                	mov    %eax,%edx
80100d79:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100d7c:	29 d0                	sub    %edx,%eax
80100d7e:	83 e8 01             	sub    $0x1,%eax
80100d81:	83 e0 fc             	and    $0xfffffffc,%eax
80100d84:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d8a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d91:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d94:	01 d0                	add    %edx,%eax
80100d96:	8b 00                	mov    (%eax),%eax
80100d98:	83 ec 0c             	sub    $0xc,%esp
80100d9b:	50                   	push   %eax
80100d9c:	e8 44 48 00 00       	call   801055e5 <strlen>
80100da1:	83 c4 10             	add    $0x10,%esp
80100da4:	83 c0 01             	add    $0x1,%eax
80100da7:	89 c1                	mov    %eax,%ecx
80100da9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dac:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100db3:	8b 45 0c             	mov    0xc(%ebp),%eax
80100db6:	01 d0                	add    %edx,%eax
80100db8:	8b 00                	mov    (%eax),%eax
80100dba:	51                   	push   %ecx
80100dbb:	50                   	push   %eax
80100dbc:	ff 75 dc             	pushl  -0x24(%ebp)
80100dbf:	ff 75 d4             	pushl  -0x2c(%ebp)
80100dc2:	e8 0f 78 00 00       	call   801085d6 <copyout>
80100dc7:	83 c4 10             	add    $0x10,%esp
80100dca:	85 c0                	test   %eax,%eax
80100dcc:	0f 88 6b 01 00 00    	js     80100f3d <exec+0x3cc>
      goto bad;
    ustack[3+argc] = sp;
80100dd2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dd5:	8d 50 03             	lea    0x3(%eax),%edx
80100dd8:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100ddb:	89 84 95 40 ff ff ff 	mov    %eax,-0xc0(%ebp,%edx,4)
  for(argc = 0; argv[argc]; argc++) {
80100de2:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100de6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100de9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100df0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100df3:	01 d0                	add    %edx,%eax
80100df5:	8b 00                	mov    (%eax),%eax
80100df7:	85 c0                	test   %eax,%eax
80100df9:	0f 85 51 ff ff ff    	jne    80100d50 <exec+0x1df>
  }
  ustack[3+argc] = 0;
80100dff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e02:	83 c0 03             	add    $0x3,%eax
80100e05:	c7 84 85 40 ff ff ff 	movl   $0x0,-0xc0(%ebp,%eax,4)
80100e0c:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100e10:	c7 85 40 ff ff ff ff 	movl   $0xffffffff,-0xc0(%ebp)
80100e17:	ff ff ff 
  ustack[1] = argc;
80100e1a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e1d:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e23:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e26:	83 c0 01             	add    $0x1,%eax
80100e29:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e30:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e33:	29 d0                	sub    %edx,%eax
80100e35:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

  sp -= (3+argc+1) * 4;
80100e3b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e3e:	83 c0 04             	add    $0x4,%eax
80100e41:	c1 e0 02             	shl    $0x2,%eax
80100e44:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100e47:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e4a:	83 c0 04             	add    $0x4,%eax
80100e4d:	c1 e0 02             	shl    $0x2,%eax
80100e50:	50                   	push   %eax
80100e51:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
80100e57:	50                   	push   %eax
80100e58:	ff 75 dc             	pushl  -0x24(%ebp)
80100e5b:	ff 75 d4             	pushl  -0x2c(%ebp)
80100e5e:	e8 73 77 00 00       	call   801085d6 <copyout>
80100e63:	83 c4 10             	add    $0x10,%esp
80100e66:	85 c0                	test   %eax,%eax
80100e68:	0f 88 d2 00 00 00    	js     80100f40 <exec+0x3cf>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e6e:	8b 45 08             	mov    0x8(%ebp),%eax
80100e71:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100e74:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e77:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100e7a:	eb 17                	jmp    80100e93 <exec+0x322>
    if(*s == '/')
80100e7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e7f:	0f b6 00             	movzbl (%eax),%eax
80100e82:	3c 2f                	cmp    $0x2f,%al
80100e84:	75 09                	jne    80100e8f <exec+0x31e>
      last = s+1;
80100e86:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e89:	83 c0 01             	add    $0x1,%eax
80100e8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(last=s=path; *s; s++)
80100e8f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100e93:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e96:	0f b6 00             	movzbl (%eax),%eax
80100e99:	84 c0                	test   %al,%al
80100e9b:	75 df                	jne    80100e7c <exec+0x30b>
  safestrcpy(proc->name, last, sizeof(proc->name));
80100e9d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ea3:	83 c0 6c             	add    $0x6c,%eax
80100ea6:	83 ec 04             	sub    $0x4,%esp
80100ea9:	6a 10                	push   $0x10
80100eab:	ff 75 f0             	pushl  -0x10(%ebp)
80100eae:	50                   	push   %eax
80100eaf:	e8 e7 46 00 00       	call   8010559b <safestrcpy>
80100eb4:	83 c4 10             	add    $0x10,%esp

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100eb7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ebd:	8b 40 04             	mov    0x4(%eax),%eax
80100ec0:	89 45 d0             	mov    %eax,-0x30(%ebp)
  proc->pgdir = pgdir;
80100ec3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ec9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100ecc:	89 50 04             	mov    %edx,0x4(%eax)
  proc->sz = sz;
80100ecf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ed5:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100ed8:	89 10                	mov    %edx,(%eax)
  proc->tf->eip = elf.entry;  // main
80100eda:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ee0:	8b 40 18             	mov    0x18(%eax),%eax
80100ee3:	8b 95 24 ff ff ff    	mov    -0xdc(%ebp),%edx
80100ee9:	89 50 38             	mov    %edx,0x38(%eax)
  proc->tf->esp = sp;
80100eec:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ef2:	8b 40 18             	mov    0x18(%eax),%eax
80100ef5:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100ef8:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(proc);
80100efb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f01:	83 ec 0c             	sub    $0xc,%esp
80100f04:	50                   	push   %eax
80100f05:	e8 2f 70 00 00       	call   80107f39 <switchuvm>
80100f0a:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
80100f0d:	83 ec 0c             	sub    $0xc,%esp
80100f10:	ff 75 d0             	pushl  -0x30(%ebp)
80100f13:	e8 67 74 00 00       	call   8010837f <freevm>
80100f18:	83 c4 10             	add    $0x10,%esp
  return 0;
80100f1b:	b8 00 00 00 00       	mov    $0x0,%eax
80100f20:	eb 51                	jmp    80100f73 <exec+0x402>
    goto bad;
80100f22:	90                   	nop
80100f23:	eb 1c                	jmp    80100f41 <exec+0x3d0>
    goto bad;
80100f25:	90                   	nop
80100f26:	eb 19                	jmp    80100f41 <exec+0x3d0>
    goto bad;
80100f28:	90                   	nop
80100f29:	eb 16                	jmp    80100f41 <exec+0x3d0>
      goto bad;
80100f2b:	90                   	nop
80100f2c:	eb 13                	jmp    80100f41 <exec+0x3d0>
      goto bad;
80100f2e:	90                   	nop
80100f2f:	eb 10                	jmp    80100f41 <exec+0x3d0>
      goto bad;
80100f31:	90                   	nop
80100f32:	eb 0d                	jmp    80100f41 <exec+0x3d0>
      goto bad;
80100f34:	90                   	nop
80100f35:	eb 0a                	jmp    80100f41 <exec+0x3d0>
    goto bad;
80100f37:	90                   	nop
80100f38:	eb 07                	jmp    80100f41 <exec+0x3d0>
      goto bad;
80100f3a:	90                   	nop
80100f3b:	eb 04                	jmp    80100f41 <exec+0x3d0>
      goto bad;
80100f3d:	90                   	nop
80100f3e:	eb 01                	jmp    80100f41 <exec+0x3d0>
    goto bad;
80100f40:	90                   	nop

 bad:
  if(pgdir)
80100f41:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100f45:	74 0e                	je     80100f55 <exec+0x3e4>
    freevm(pgdir);
80100f47:	83 ec 0c             	sub    $0xc,%esp
80100f4a:	ff 75 d4             	pushl  -0x2c(%ebp)
80100f4d:	e8 2d 74 00 00       	call   8010837f <freevm>
80100f52:	83 c4 10             	add    $0x10,%esp
  if(ip){
80100f55:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100f59:	74 13                	je     80100f6e <exec+0x3fd>
    iunlockput(ip);
80100f5b:	83 ec 0c             	sub    $0xc,%esp
80100f5e:	ff 75 d8             	pushl  -0x28(%ebp)
80100f61:	e8 c4 0c 00 00       	call   80101c2a <iunlockput>
80100f66:	83 c4 10             	add    $0x10,%esp
    end_op();
80100f69:	e8 6b 26 00 00       	call   801035d9 <end_op>
  }
  return -1;
80100f6e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f73:	c9                   	leave  
80100f74:	c3                   	ret    

80100f75 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100f75:	55                   	push   %ebp
80100f76:	89 e5                	mov    %esp,%ebp
80100f78:	83 ec 08             	sub    $0x8,%esp
  initlock(&ftable.lock, "ftable");
80100f7b:	83 ec 08             	sub    $0x8,%esp
80100f7e:	68 da 86 10 80       	push   $0x801086da
80100f83:	68 20 08 11 80       	push   $0x80110820
80100f88:	e8 86 41 00 00       	call   80105113 <initlock>
80100f8d:	83 c4 10             	add    $0x10,%esp
}
80100f90:	90                   	nop
80100f91:	c9                   	leave  
80100f92:	c3                   	ret    

80100f93 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100f93:	55                   	push   %ebp
80100f94:	89 e5                	mov    %esp,%ebp
80100f96:	83 ec 18             	sub    $0x18,%esp
  struct file *f;

  acquire(&ftable.lock);
80100f99:	83 ec 0c             	sub    $0xc,%esp
80100f9c:	68 20 08 11 80       	push   $0x80110820
80100fa1:	e8 8f 41 00 00       	call   80105135 <acquire>
80100fa6:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100fa9:	c7 45 f4 54 08 11 80 	movl   $0x80110854,-0xc(%ebp)
80100fb0:	eb 2d                	jmp    80100fdf <filealloc+0x4c>
    if(f->ref == 0){
80100fb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fb5:	8b 40 04             	mov    0x4(%eax),%eax
80100fb8:	85 c0                	test   %eax,%eax
80100fba:	75 1f                	jne    80100fdb <filealloc+0x48>
      f->ref = 1;
80100fbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fbf:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80100fc6:	83 ec 0c             	sub    $0xc,%esp
80100fc9:	68 20 08 11 80       	push   $0x80110820
80100fce:	e8 c9 41 00 00       	call   8010519c <release>
80100fd3:	83 c4 10             	add    $0x10,%esp
      return f;
80100fd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fd9:	eb 23                	jmp    80100ffe <filealloc+0x6b>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100fdb:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80100fdf:	b8 b4 11 11 80       	mov    $0x801111b4,%eax
80100fe4:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80100fe7:	72 c9                	jb     80100fb2 <filealloc+0x1f>
    }
  }
  release(&ftable.lock);
80100fe9:	83 ec 0c             	sub    $0xc,%esp
80100fec:	68 20 08 11 80       	push   $0x80110820
80100ff1:	e8 a6 41 00 00       	call   8010519c <release>
80100ff6:	83 c4 10             	add    $0x10,%esp
  return 0;
80100ff9:	b8 00 00 00 00       	mov    $0x0,%eax
}
80100ffe:	c9                   	leave  
80100fff:	c3                   	ret    

80101000 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80101000:	55                   	push   %ebp
80101001:	89 e5                	mov    %esp,%ebp
80101003:	83 ec 08             	sub    $0x8,%esp
  acquire(&ftable.lock);
80101006:	83 ec 0c             	sub    $0xc,%esp
80101009:	68 20 08 11 80       	push   $0x80110820
8010100e:	e8 22 41 00 00       	call   80105135 <acquire>
80101013:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
80101016:	8b 45 08             	mov    0x8(%ebp),%eax
80101019:	8b 40 04             	mov    0x4(%eax),%eax
8010101c:	85 c0                	test   %eax,%eax
8010101e:	7f 0d                	jg     8010102d <filedup+0x2d>
    panic("filedup");
80101020:	83 ec 0c             	sub    $0xc,%esp
80101023:	68 e1 86 10 80       	push   $0x801086e1
80101028:	e8 39 f5 ff ff       	call   80100566 <panic>
  f->ref++;
8010102d:	8b 45 08             	mov    0x8(%ebp),%eax
80101030:	8b 40 04             	mov    0x4(%eax),%eax
80101033:	8d 50 01             	lea    0x1(%eax),%edx
80101036:	8b 45 08             	mov    0x8(%ebp),%eax
80101039:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
8010103c:	83 ec 0c             	sub    $0xc,%esp
8010103f:	68 20 08 11 80       	push   $0x80110820
80101044:	e8 53 41 00 00       	call   8010519c <release>
80101049:	83 c4 10             	add    $0x10,%esp
  return f;
8010104c:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010104f:	c9                   	leave  
80101050:	c3                   	ret    

80101051 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101051:	55                   	push   %ebp
80101052:	89 e5                	mov    %esp,%ebp
80101054:	83 ec 28             	sub    $0x28,%esp
  struct file ff;

  acquire(&ftable.lock);
80101057:	83 ec 0c             	sub    $0xc,%esp
8010105a:	68 20 08 11 80       	push   $0x80110820
8010105f:	e8 d1 40 00 00       	call   80105135 <acquire>
80101064:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
80101067:	8b 45 08             	mov    0x8(%ebp),%eax
8010106a:	8b 40 04             	mov    0x4(%eax),%eax
8010106d:	85 c0                	test   %eax,%eax
8010106f:	7f 0d                	jg     8010107e <fileclose+0x2d>
    panic("fileclose");
80101071:	83 ec 0c             	sub    $0xc,%esp
80101074:	68 e9 86 10 80       	push   $0x801086e9
80101079:	e8 e8 f4 ff ff       	call   80100566 <panic>
  if(--f->ref > 0){
8010107e:	8b 45 08             	mov    0x8(%ebp),%eax
80101081:	8b 40 04             	mov    0x4(%eax),%eax
80101084:	8d 50 ff             	lea    -0x1(%eax),%edx
80101087:	8b 45 08             	mov    0x8(%ebp),%eax
8010108a:	89 50 04             	mov    %edx,0x4(%eax)
8010108d:	8b 45 08             	mov    0x8(%ebp),%eax
80101090:	8b 40 04             	mov    0x4(%eax),%eax
80101093:	85 c0                	test   %eax,%eax
80101095:	7e 15                	jle    801010ac <fileclose+0x5b>
    release(&ftable.lock);
80101097:	83 ec 0c             	sub    $0xc,%esp
8010109a:	68 20 08 11 80       	push   $0x80110820
8010109f:	e8 f8 40 00 00       	call   8010519c <release>
801010a4:	83 c4 10             	add    $0x10,%esp
801010a7:	e9 8b 00 00 00       	jmp    80101137 <fileclose+0xe6>
    return;
  }
  ff = *f;
801010ac:	8b 45 08             	mov    0x8(%ebp),%eax
801010af:	8b 10                	mov    (%eax),%edx
801010b1:	89 55 e0             	mov    %edx,-0x20(%ebp)
801010b4:	8b 50 04             	mov    0x4(%eax),%edx
801010b7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801010ba:	8b 50 08             	mov    0x8(%eax),%edx
801010bd:	89 55 e8             	mov    %edx,-0x18(%ebp)
801010c0:	8b 50 0c             	mov    0xc(%eax),%edx
801010c3:	89 55 ec             	mov    %edx,-0x14(%ebp)
801010c6:	8b 50 10             	mov    0x10(%eax),%edx
801010c9:	89 55 f0             	mov    %edx,-0x10(%ebp)
801010cc:	8b 40 14             	mov    0x14(%eax),%eax
801010cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
801010d2:	8b 45 08             	mov    0x8(%ebp),%eax
801010d5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
801010dc:	8b 45 08             	mov    0x8(%ebp),%eax
801010df:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
801010e5:	83 ec 0c             	sub    $0xc,%esp
801010e8:	68 20 08 11 80       	push   $0x80110820
801010ed:	e8 aa 40 00 00       	call   8010519c <release>
801010f2:	83 c4 10             	add    $0x10,%esp
  
  if(ff.type == FD_PIPE)
801010f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010f8:	83 f8 01             	cmp    $0x1,%eax
801010fb:	75 19                	jne    80101116 <fileclose+0xc5>
    pipeclose(ff.pipe, ff.writable);
801010fd:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
80101101:	0f be d0             	movsbl %al,%edx
80101104:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101107:	83 ec 08             	sub    $0x8,%esp
8010110a:	52                   	push   %edx
8010110b:	50                   	push   %eax
8010110c:	e8 83 30 00 00       	call   80104194 <pipeclose>
80101111:	83 c4 10             	add    $0x10,%esp
80101114:	eb 21                	jmp    80101137 <fileclose+0xe6>
  else if(ff.type == FD_INODE){
80101116:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101119:	83 f8 02             	cmp    $0x2,%eax
8010111c:	75 19                	jne    80101137 <fileclose+0xe6>
    begin_op();
8010111e:	e8 2a 24 00 00       	call   8010354d <begin_op>
    iput(ff.ip);
80101123:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101126:	83 ec 0c             	sub    $0xc,%esp
80101129:	50                   	push   %eax
8010112a:	e8 0b 0a 00 00       	call   80101b3a <iput>
8010112f:	83 c4 10             	add    $0x10,%esp
    end_op();
80101132:	e8 a2 24 00 00       	call   801035d9 <end_op>
  }
}
80101137:	c9                   	leave  
80101138:	c3                   	ret    

80101139 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101139:	55                   	push   %ebp
8010113a:	89 e5                	mov    %esp,%ebp
8010113c:	83 ec 08             	sub    $0x8,%esp
  if(f->type == FD_INODE){
8010113f:	8b 45 08             	mov    0x8(%ebp),%eax
80101142:	8b 00                	mov    (%eax),%eax
80101144:	83 f8 02             	cmp    $0x2,%eax
80101147:	75 40                	jne    80101189 <filestat+0x50>
    ilock(f->ip);
80101149:	8b 45 08             	mov    0x8(%ebp),%eax
8010114c:	8b 40 10             	mov    0x10(%eax),%eax
8010114f:	83 ec 0c             	sub    $0xc,%esp
80101152:	50                   	push   %eax
80101153:	e8 12 08 00 00       	call   8010196a <ilock>
80101158:	83 c4 10             	add    $0x10,%esp
    stati(f->ip, st);
8010115b:	8b 45 08             	mov    0x8(%ebp),%eax
8010115e:	8b 40 10             	mov    0x10(%eax),%eax
80101161:	83 ec 08             	sub    $0x8,%esp
80101164:	ff 75 0c             	pushl  0xc(%ebp)
80101167:	50                   	push   %eax
80101168:	e8 25 0d 00 00       	call   80101e92 <stati>
8010116d:	83 c4 10             	add    $0x10,%esp
    iunlock(f->ip);
80101170:	8b 45 08             	mov    0x8(%ebp),%eax
80101173:	8b 40 10             	mov    0x10(%eax),%eax
80101176:	83 ec 0c             	sub    $0xc,%esp
80101179:	50                   	push   %eax
8010117a:	e8 49 09 00 00       	call   80101ac8 <iunlock>
8010117f:	83 c4 10             	add    $0x10,%esp
    return 0;
80101182:	b8 00 00 00 00       	mov    $0x0,%eax
80101187:	eb 05                	jmp    8010118e <filestat+0x55>
  }
  return -1;
80101189:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010118e:	c9                   	leave  
8010118f:	c3                   	ret    

80101190 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101190:	55                   	push   %ebp
80101191:	89 e5                	mov    %esp,%ebp
80101193:	83 ec 18             	sub    $0x18,%esp
  int r;

  if(f->readable == 0)
80101196:	8b 45 08             	mov    0x8(%ebp),%eax
80101199:	0f b6 40 08          	movzbl 0x8(%eax),%eax
8010119d:	84 c0                	test   %al,%al
8010119f:	75 0a                	jne    801011ab <fileread+0x1b>
    return -1;
801011a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801011a6:	e9 9b 00 00 00       	jmp    80101246 <fileread+0xb6>
  if(f->type == FD_PIPE)
801011ab:	8b 45 08             	mov    0x8(%ebp),%eax
801011ae:	8b 00                	mov    (%eax),%eax
801011b0:	83 f8 01             	cmp    $0x1,%eax
801011b3:	75 1a                	jne    801011cf <fileread+0x3f>
    return piperead(f->pipe, addr, n);
801011b5:	8b 45 08             	mov    0x8(%ebp),%eax
801011b8:	8b 40 0c             	mov    0xc(%eax),%eax
801011bb:	83 ec 04             	sub    $0x4,%esp
801011be:	ff 75 10             	pushl  0x10(%ebp)
801011c1:	ff 75 0c             	pushl  0xc(%ebp)
801011c4:	50                   	push   %eax
801011c5:	e8 72 31 00 00       	call   8010433c <piperead>
801011ca:	83 c4 10             	add    $0x10,%esp
801011cd:	eb 77                	jmp    80101246 <fileread+0xb6>
  if(f->type == FD_INODE){
801011cf:	8b 45 08             	mov    0x8(%ebp),%eax
801011d2:	8b 00                	mov    (%eax),%eax
801011d4:	83 f8 02             	cmp    $0x2,%eax
801011d7:	75 60                	jne    80101239 <fileread+0xa9>
    ilock(f->ip);
801011d9:	8b 45 08             	mov    0x8(%ebp),%eax
801011dc:	8b 40 10             	mov    0x10(%eax),%eax
801011df:	83 ec 0c             	sub    $0xc,%esp
801011e2:	50                   	push   %eax
801011e3:	e8 82 07 00 00       	call   8010196a <ilock>
801011e8:	83 c4 10             	add    $0x10,%esp
    if((r = readi(f->ip, addr, f->off, n)) > 0)
801011eb:	8b 4d 10             	mov    0x10(%ebp),%ecx
801011ee:	8b 45 08             	mov    0x8(%ebp),%eax
801011f1:	8b 50 14             	mov    0x14(%eax),%edx
801011f4:	8b 45 08             	mov    0x8(%ebp),%eax
801011f7:	8b 40 10             	mov    0x10(%eax),%eax
801011fa:	51                   	push   %ecx
801011fb:	52                   	push   %edx
801011fc:	ff 75 0c             	pushl  0xc(%ebp)
801011ff:	50                   	push   %eax
80101200:	e8 d3 0c 00 00       	call   80101ed8 <readi>
80101205:	83 c4 10             	add    $0x10,%esp
80101208:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010120b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010120f:	7e 11                	jle    80101222 <fileread+0x92>
      f->off += r;
80101211:	8b 45 08             	mov    0x8(%ebp),%eax
80101214:	8b 50 14             	mov    0x14(%eax),%edx
80101217:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010121a:	01 c2                	add    %eax,%edx
8010121c:	8b 45 08             	mov    0x8(%ebp),%eax
8010121f:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
80101222:	8b 45 08             	mov    0x8(%ebp),%eax
80101225:	8b 40 10             	mov    0x10(%eax),%eax
80101228:	83 ec 0c             	sub    $0xc,%esp
8010122b:	50                   	push   %eax
8010122c:	e8 97 08 00 00       	call   80101ac8 <iunlock>
80101231:	83 c4 10             	add    $0x10,%esp
    return r;
80101234:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101237:	eb 0d                	jmp    80101246 <fileread+0xb6>
  }
  panic("fileread");
80101239:	83 ec 0c             	sub    $0xc,%esp
8010123c:	68 f3 86 10 80       	push   $0x801086f3
80101241:	e8 20 f3 ff ff       	call   80100566 <panic>
}
80101246:	c9                   	leave  
80101247:	c3                   	ret    

80101248 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101248:	55                   	push   %ebp
80101249:	89 e5                	mov    %esp,%ebp
8010124b:	53                   	push   %ebx
8010124c:	83 ec 14             	sub    $0x14,%esp
  int r;

  if(f->writable == 0)
8010124f:	8b 45 08             	mov    0x8(%ebp),%eax
80101252:	0f b6 40 09          	movzbl 0x9(%eax),%eax
80101256:	84 c0                	test   %al,%al
80101258:	75 0a                	jne    80101264 <filewrite+0x1c>
    return -1;
8010125a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010125f:	e9 1b 01 00 00       	jmp    8010137f <filewrite+0x137>
  if(f->type == FD_PIPE)
80101264:	8b 45 08             	mov    0x8(%ebp),%eax
80101267:	8b 00                	mov    (%eax),%eax
80101269:	83 f8 01             	cmp    $0x1,%eax
8010126c:	75 1d                	jne    8010128b <filewrite+0x43>
    return pipewrite(f->pipe, addr, n);
8010126e:	8b 45 08             	mov    0x8(%ebp),%eax
80101271:	8b 40 0c             	mov    0xc(%eax),%eax
80101274:	83 ec 04             	sub    $0x4,%esp
80101277:	ff 75 10             	pushl  0x10(%ebp)
8010127a:	ff 75 0c             	pushl  0xc(%ebp)
8010127d:	50                   	push   %eax
8010127e:	e8 bb 2f 00 00       	call   8010423e <pipewrite>
80101283:	83 c4 10             	add    $0x10,%esp
80101286:	e9 f4 00 00 00       	jmp    8010137f <filewrite+0x137>
  if(f->type == FD_INODE){
8010128b:	8b 45 08             	mov    0x8(%ebp),%eax
8010128e:	8b 00                	mov    (%eax),%eax
80101290:	83 f8 02             	cmp    $0x2,%eax
80101293:	0f 85 d9 00 00 00    	jne    80101372 <filewrite+0x12a>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
80101299:	c7 45 ec 00 1a 00 00 	movl   $0x1a00,-0x14(%ebp)
    int i = 0;
801012a0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
801012a7:	e9 a3 00 00 00       	jmp    8010134f <filewrite+0x107>
      int n1 = n - i;
801012ac:	8b 45 10             	mov    0x10(%ebp),%eax
801012af:	2b 45 f4             	sub    -0xc(%ebp),%eax
801012b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
801012b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801012b8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801012bb:	7e 06                	jle    801012c3 <filewrite+0x7b>
        n1 = max;
801012bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
801012c0:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_op();
801012c3:	e8 85 22 00 00       	call   8010354d <begin_op>
      ilock(f->ip);
801012c8:	8b 45 08             	mov    0x8(%ebp),%eax
801012cb:	8b 40 10             	mov    0x10(%eax),%eax
801012ce:	83 ec 0c             	sub    $0xc,%esp
801012d1:	50                   	push   %eax
801012d2:	e8 93 06 00 00       	call   8010196a <ilock>
801012d7:	83 c4 10             	add    $0x10,%esp
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801012da:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801012dd:	8b 45 08             	mov    0x8(%ebp),%eax
801012e0:	8b 50 14             	mov    0x14(%eax),%edx
801012e3:	8b 5d f4             	mov    -0xc(%ebp),%ebx
801012e6:	8b 45 0c             	mov    0xc(%ebp),%eax
801012e9:	01 c3                	add    %eax,%ebx
801012eb:	8b 45 08             	mov    0x8(%ebp),%eax
801012ee:	8b 40 10             	mov    0x10(%eax),%eax
801012f1:	51                   	push   %ecx
801012f2:	52                   	push   %edx
801012f3:	53                   	push   %ebx
801012f4:	50                   	push   %eax
801012f5:	e8 35 0d 00 00       	call   8010202f <writei>
801012fa:	83 c4 10             	add    $0x10,%esp
801012fd:	89 45 e8             	mov    %eax,-0x18(%ebp)
80101300:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101304:	7e 11                	jle    80101317 <filewrite+0xcf>
        f->off += r;
80101306:	8b 45 08             	mov    0x8(%ebp),%eax
80101309:	8b 50 14             	mov    0x14(%eax),%edx
8010130c:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010130f:	01 c2                	add    %eax,%edx
80101311:	8b 45 08             	mov    0x8(%ebp),%eax
80101314:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
80101317:	8b 45 08             	mov    0x8(%ebp),%eax
8010131a:	8b 40 10             	mov    0x10(%eax),%eax
8010131d:	83 ec 0c             	sub    $0xc,%esp
80101320:	50                   	push   %eax
80101321:	e8 a2 07 00 00       	call   80101ac8 <iunlock>
80101326:	83 c4 10             	add    $0x10,%esp
      end_op();
80101329:	e8 ab 22 00 00       	call   801035d9 <end_op>

      if(r < 0)
8010132e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101332:	78 29                	js     8010135d <filewrite+0x115>
        break;
      if(r != n1)
80101334:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101337:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010133a:	74 0d                	je     80101349 <filewrite+0x101>
        panic("short filewrite");
8010133c:	83 ec 0c             	sub    $0xc,%esp
8010133f:	68 fc 86 10 80       	push   $0x801086fc
80101344:	e8 1d f2 ff ff       	call   80100566 <panic>
      i += r;
80101349:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010134c:	01 45 f4             	add    %eax,-0xc(%ebp)
    while(i < n){
8010134f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101352:	3b 45 10             	cmp    0x10(%ebp),%eax
80101355:	0f 8c 51 ff ff ff    	jl     801012ac <filewrite+0x64>
8010135b:	eb 01                	jmp    8010135e <filewrite+0x116>
        break;
8010135d:	90                   	nop
    }
    return i == n ? n : -1;
8010135e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101361:	3b 45 10             	cmp    0x10(%ebp),%eax
80101364:	75 05                	jne    8010136b <filewrite+0x123>
80101366:	8b 45 10             	mov    0x10(%ebp),%eax
80101369:	eb 14                	jmp    8010137f <filewrite+0x137>
8010136b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101370:	eb 0d                	jmp    8010137f <filewrite+0x137>
  }
  panic("filewrite");
80101372:	83 ec 0c             	sub    $0xc,%esp
80101375:	68 0c 87 10 80       	push   $0x8010870c
8010137a:	e8 e7 f1 ff ff       	call   80100566 <panic>
}
8010137f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101382:	c9                   	leave  
80101383:	c3                   	ret    

80101384 <readsb>:
struct superblock sb;   // there should be one per dev, but we run with one dev

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101384:	55                   	push   %ebp
80101385:	89 e5                	mov    %esp,%ebp
80101387:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
8010138a:	8b 45 08             	mov    0x8(%ebp),%eax
8010138d:	83 ec 08             	sub    $0x8,%esp
80101390:	6a 01                	push   $0x1
80101392:	50                   	push   %eax
80101393:	e8 1e ee ff ff       	call   801001b6 <bread>
80101398:	83 c4 10             	add    $0x10,%esp
8010139b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
8010139e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013a1:	83 c0 18             	add    $0x18,%eax
801013a4:	83 ec 04             	sub    $0x4,%esp
801013a7:	6a 1c                	push   $0x1c
801013a9:	50                   	push   %eax
801013aa:	ff 75 0c             	pushl  0xc(%ebp)
801013ad:	e8 a5 40 00 00       	call   80105457 <memmove>
801013b2:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801013b5:	83 ec 0c             	sub    $0xc,%esp
801013b8:	ff 75 f4             	pushl  -0xc(%ebp)
801013bb:	e8 6e ee ff ff       	call   8010022e <brelse>
801013c0:	83 c4 10             	add    $0x10,%esp
}
801013c3:	90                   	nop
801013c4:	c9                   	leave  
801013c5:	c3                   	ret    

801013c6 <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
801013c6:	55                   	push   %ebp
801013c7:	89 e5                	mov    %esp,%ebp
801013c9:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, bno);
801013cc:	8b 55 0c             	mov    0xc(%ebp),%edx
801013cf:	8b 45 08             	mov    0x8(%ebp),%eax
801013d2:	83 ec 08             	sub    $0x8,%esp
801013d5:	52                   	push   %edx
801013d6:	50                   	push   %eax
801013d7:	e8 da ed ff ff       	call   801001b6 <bread>
801013dc:	83 c4 10             	add    $0x10,%esp
801013df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
801013e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013e5:	83 c0 18             	add    $0x18,%eax
801013e8:	83 ec 04             	sub    $0x4,%esp
801013eb:	68 00 02 00 00       	push   $0x200
801013f0:	6a 00                	push   $0x0
801013f2:	50                   	push   %eax
801013f3:	e8 a0 3f 00 00       	call   80105398 <memset>
801013f8:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
801013fb:	83 ec 0c             	sub    $0xc,%esp
801013fe:	ff 75 f4             	pushl  -0xc(%ebp)
80101401:	e8 7f 23 00 00       	call   80103785 <log_write>
80101406:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101409:	83 ec 0c             	sub    $0xc,%esp
8010140c:	ff 75 f4             	pushl  -0xc(%ebp)
8010140f:	e8 1a ee ff ff       	call   8010022e <brelse>
80101414:	83 c4 10             	add    $0x10,%esp
}
80101417:	90                   	nop
80101418:	c9                   	leave  
80101419:	c3                   	ret    

8010141a <balloc>:
// Blocks. 

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
8010141a:	55                   	push   %ebp
8010141b:	89 e5                	mov    %esp,%ebp
8010141d:	83 ec 18             	sub    $0x18,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
80101420:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101427:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010142e:	e9 13 01 00 00       	jmp    80101546 <balloc+0x12c>
    bp = bread(dev, BBLOCK(b, sb));
80101433:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101436:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
8010143c:	85 c0                	test   %eax,%eax
8010143e:	0f 48 c2             	cmovs  %edx,%eax
80101441:	c1 f8 0c             	sar    $0xc,%eax
80101444:	89 c2                	mov    %eax,%edx
80101446:	a1 38 12 11 80       	mov    0x80111238,%eax
8010144b:	01 d0                	add    %edx,%eax
8010144d:	83 ec 08             	sub    $0x8,%esp
80101450:	50                   	push   %eax
80101451:	ff 75 08             	pushl  0x8(%ebp)
80101454:	e8 5d ed ff ff       	call   801001b6 <bread>
80101459:	83 c4 10             	add    $0x10,%esp
8010145c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010145f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101466:	e9 a6 00 00 00       	jmp    80101511 <balloc+0xf7>
      m = 1 << (bi % 8);
8010146b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010146e:	99                   	cltd   
8010146f:	c1 ea 1d             	shr    $0x1d,%edx
80101472:	01 d0                	add    %edx,%eax
80101474:	83 e0 07             	and    $0x7,%eax
80101477:	29 d0                	sub    %edx,%eax
80101479:	ba 01 00 00 00       	mov    $0x1,%edx
8010147e:	89 c1                	mov    %eax,%ecx
80101480:	d3 e2                	shl    %cl,%edx
80101482:	89 d0                	mov    %edx,%eax
80101484:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101487:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010148a:	8d 50 07             	lea    0x7(%eax),%edx
8010148d:	85 c0                	test   %eax,%eax
8010148f:	0f 48 c2             	cmovs  %edx,%eax
80101492:	c1 f8 03             	sar    $0x3,%eax
80101495:	89 c2                	mov    %eax,%edx
80101497:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010149a:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
8010149f:	0f b6 c0             	movzbl %al,%eax
801014a2:	23 45 e8             	and    -0x18(%ebp),%eax
801014a5:	85 c0                	test   %eax,%eax
801014a7:	75 64                	jne    8010150d <balloc+0xf3>
        bp->data[bi/8] |= m;  // Mark block in use.
801014a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014ac:	8d 50 07             	lea    0x7(%eax),%edx
801014af:	85 c0                	test   %eax,%eax
801014b1:	0f 48 c2             	cmovs  %edx,%eax
801014b4:	c1 f8 03             	sar    $0x3,%eax
801014b7:	8b 55 ec             	mov    -0x14(%ebp),%edx
801014ba:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
801014bf:	89 d1                	mov    %edx,%ecx
801014c1:	8b 55 e8             	mov    -0x18(%ebp),%edx
801014c4:	09 ca                	or     %ecx,%edx
801014c6:	89 d1                	mov    %edx,%ecx
801014c8:	8b 55 ec             	mov    -0x14(%ebp),%edx
801014cb:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
        log_write(bp);
801014cf:	83 ec 0c             	sub    $0xc,%esp
801014d2:	ff 75 ec             	pushl  -0x14(%ebp)
801014d5:	e8 ab 22 00 00       	call   80103785 <log_write>
801014da:	83 c4 10             	add    $0x10,%esp
        brelse(bp);
801014dd:	83 ec 0c             	sub    $0xc,%esp
801014e0:	ff 75 ec             	pushl  -0x14(%ebp)
801014e3:	e8 46 ed ff ff       	call   8010022e <brelse>
801014e8:	83 c4 10             	add    $0x10,%esp
        bzero(dev, b + bi);
801014eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014f1:	01 c2                	add    %eax,%edx
801014f3:	8b 45 08             	mov    0x8(%ebp),%eax
801014f6:	83 ec 08             	sub    $0x8,%esp
801014f9:	52                   	push   %edx
801014fa:	50                   	push   %eax
801014fb:	e8 c6 fe ff ff       	call   801013c6 <bzero>
80101500:	83 c4 10             	add    $0x10,%esp
        return b + bi;
80101503:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101506:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101509:	01 d0                	add    %edx,%eax
8010150b:	eb 57                	jmp    80101564 <balloc+0x14a>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010150d:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101511:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
80101518:	7f 17                	jg     80101531 <balloc+0x117>
8010151a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010151d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101520:	01 d0                	add    %edx,%eax
80101522:	89 c2                	mov    %eax,%edx
80101524:	a1 20 12 11 80       	mov    0x80111220,%eax
80101529:	39 c2                	cmp    %eax,%edx
8010152b:	0f 82 3a ff ff ff    	jb     8010146b <balloc+0x51>
      }
    }
    brelse(bp);
80101531:	83 ec 0c             	sub    $0xc,%esp
80101534:	ff 75 ec             	pushl  -0x14(%ebp)
80101537:	e8 f2 ec ff ff       	call   8010022e <brelse>
8010153c:	83 c4 10             	add    $0x10,%esp
  for(b = 0; b < sb.size; b += BPB){
8010153f:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80101546:	8b 15 20 12 11 80    	mov    0x80111220,%edx
8010154c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010154f:	39 c2                	cmp    %eax,%edx
80101551:	0f 87 dc fe ff ff    	ja     80101433 <balloc+0x19>
  }
  panic("balloc: out of blocks");
80101557:	83 ec 0c             	sub    $0xc,%esp
8010155a:	68 18 87 10 80       	push   $0x80108718
8010155f:	e8 02 f0 ff ff       	call   80100566 <panic>
}
80101564:	c9                   	leave  
80101565:	c3                   	ret    

80101566 <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101566:	55                   	push   %ebp
80101567:	89 e5                	mov    %esp,%ebp
80101569:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
8010156c:	83 ec 08             	sub    $0x8,%esp
8010156f:	68 20 12 11 80       	push   $0x80111220
80101574:	ff 75 08             	pushl  0x8(%ebp)
80101577:	e8 08 fe ff ff       	call   80101384 <readsb>
8010157c:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
8010157f:	8b 45 0c             	mov    0xc(%ebp),%eax
80101582:	c1 e8 0c             	shr    $0xc,%eax
80101585:	89 c2                	mov    %eax,%edx
80101587:	a1 38 12 11 80       	mov    0x80111238,%eax
8010158c:	01 c2                	add    %eax,%edx
8010158e:	8b 45 08             	mov    0x8(%ebp),%eax
80101591:	83 ec 08             	sub    $0x8,%esp
80101594:	52                   	push   %edx
80101595:	50                   	push   %eax
80101596:	e8 1b ec ff ff       	call   801001b6 <bread>
8010159b:	83 c4 10             	add    $0x10,%esp
8010159e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
801015a1:	8b 45 0c             	mov    0xc(%ebp),%eax
801015a4:	25 ff 0f 00 00       	and    $0xfff,%eax
801015a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
801015ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015af:	99                   	cltd   
801015b0:	c1 ea 1d             	shr    $0x1d,%edx
801015b3:	01 d0                	add    %edx,%eax
801015b5:	83 e0 07             	and    $0x7,%eax
801015b8:	29 d0                	sub    %edx,%eax
801015ba:	ba 01 00 00 00       	mov    $0x1,%edx
801015bf:	89 c1                	mov    %eax,%ecx
801015c1:	d3 e2                	shl    %cl,%edx
801015c3:	89 d0                	mov    %edx,%eax
801015c5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
801015c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015cb:	8d 50 07             	lea    0x7(%eax),%edx
801015ce:	85 c0                	test   %eax,%eax
801015d0:	0f 48 c2             	cmovs  %edx,%eax
801015d3:	c1 f8 03             	sar    $0x3,%eax
801015d6:	89 c2                	mov    %eax,%edx
801015d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015db:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
801015e0:	0f b6 c0             	movzbl %al,%eax
801015e3:	23 45 ec             	and    -0x14(%ebp),%eax
801015e6:	85 c0                	test   %eax,%eax
801015e8:	75 0d                	jne    801015f7 <bfree+0x91>
    panic("freeing free block");
801015ea:	83 ec 0c             	sub    $0xc,%esp
801015ed:	68 2e 87 10 80       	push   $0x8010872e
801015f2:	e8 6f ef ff ff       	call   80100566 <panic>
  bp->data[bi/8] &= ~m;
801015f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015fa:	8d 50 07             	lea    0x7(%eax),%edx
801015fd:	85 c0                	test   %eax,%eax
801015ff:	0f 48 c2             	cmovs  %edx,%eax
80101602:	c1 f8 03             	sar    $0x3,%eax
80101605:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101608:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
8010160d:	89 d1                	mov    %edx,%ecx
8010160f:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101612:	f7 d2                	not    %edx
80101614:	21 ca                	and    %ecx,%edx
80101616:	89 d1                	mov    %edx,%ecx
80101618:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010161b:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
  log_write(bp);
8010161f:	83 ec 0c             	sub    $0xc,%esp
80101622:	ff 75 f4             	pushl  -0xc(%ebp)
80101625:	e8 5b 21 00 00       	call   80103785 <log_write>
8010162a:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
8010162d:	83 ec 0c             	sub    $0xc,%esp
80101630:	ff 75 f4             	pushl  -0xc(%ebp)
80101633:	e8 f6 eb ff ff       	call   8010022e <brelse>
80101638:	83 c4 10             	add    $0x10,%esp
}
8010163b:	90                   	nop
8010163c:	c9                   	leave  
8010163d:	c3                   	ret    

8010163e <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
8010163e:	55                   	push   %ebp
8010163f:	89 e5                	mov    %esp,%ebp
80101641:	57                   	push   %edi
80101642:	56                   	push   %esi
80101643:	53                   	push   %ebx
80101644:	83 ec 1c             	sub    $0x1c,%esp
  initlock(&icache.lock, "icache");
80101647:	83 ec 08             	sub    $0x8,%esp
8010164a:	68 41 87 10 80       	push   $0x80108741
8010164f:	68 40 12 11 80       	push   $0x80111240
80101654:	e8 ba 3a 00 00       	call   80105113 <initlock>
80101659:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
8010165c:	83 ec 08             	sub    $0x8,%esp
8010165f:	68 20 12 11 80       	push   $0x80111220
80101664:	ff 75 08             	pushl  0x8(%ebp)
80101667:	e8 18 fd ff ff       	call   80101384 <readsb>
8010166c:	83 c4 10             	add    $0x10,%esp
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d inodestart %d bmap start %d\n", sb.size,
8010166f:	a1 38 12 11 80       	mov    0x80111238,%eax
80101674:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101677:	8b 3d 34 12 11 80    	mov    0x80111234,%edi
8010167d:	8b 35 30 12 11 80    	mov    0x80111230,%esi
80101683:	8b 1d 2c 12 11 80    	mov    0x8011122c,%ebx
80101689:	8b 0d 28 12 11 80    	mov    0x80111228,%ecx
8010168f:	8b 15 24 12 11 80    	mov    0x80111224,%edx
80101695:	a1 20 12 11 80       	mov    0x80111220,%eax
8010169a:	ff 75 e4             	pushl  -0x1c(%ebp)
8010169d:	57                   	push   %edi
8010169e:	56                   	push   %esi
8010169f:	53                   	push   %ebx
801016a0:	51                   	push   %ecx
801016a1:	52                   	push   %edx
801016a2:	50                   	push   %eax
801016a3:	68 48 87 10 80       	push   $0x80108748
801016a8:	e8 19 ed ff ff       	call   801003c6 <cprintf>
801016ad:	83 c4 20             	add    $0x20,%esp
          sb.nblocks, sb.ninodes, sb.nlog, sb.logstart, sb.inodestart, sb.bmapstart);
}
801016b0:	90                   	nop
801016b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801016b4:	5b                   	pop    %ebx
801016b5:	5e                   	pop    %esi
801016b6:	5f                   	pop    %edi
801016b7:	5d                   	pop    %ebp
801016b8:	c3                   	ret    

801016b9 <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
801016b9:	55                   	push   %ebp
801016ba:	89 e5                	mov    %esp,%ebp
801016bc:	83 ec 28             	sub    $0x28,%esp
801016bf:	8b 45 0c             	mov    0xc(%ebp),%eax
801016c2:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801016c6:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
801016cd:	e9 9e 00 00 00       	jmp    80101770 <ialloc+0xb7>
    bp = bread(dev, IBLOCK(inum, sb));
801016d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016d5:	c1 e8 03             	shr    $0x3,%eax
801016d8:	89 c2                	mov    %eax,%edx
801016da:	a1 34 12 11 80       	mov    0x80111234,%eax
801016df:	01 d0                	add    %edx,%eax
801016e1:	83 ec 08             	sub    $0x8,%esp
801016e4:	50                   	push   %eax
801016e5:	ff 75 08             	pushl  0x8(%ebp)
801016e8:	e8 c9 ea ff ff       	call   801001b6 <bread>
801016ed:	83 c4 10             	add    $0x10,%esp
801016f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
801016f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016f6:	8d 50 18             	lea    0x18(%eax),%edx
801016f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016fc:	83 e0 07             	and    $0x7,%eax
801016ff:	c1 e0 06             	shl    $0x6,%eax
80101702:	01 d0                	add    %edx,%eax
80101704:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
80101707:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010170a:	0f b7 00             	movzwl (%eax),%eax
8010170d:	66 85 c0             	test   %ax,%ax
80101710:	75 4c                	jne    8010175e <ialloc+0xa5>
      memset(dip, 0, sizeof(*dip));
80101712:	83 ec 04             	sub    $0x4,%esp
80101715:	6a 40                	push   $0x40
80101717:	6a 00                	push   $0x0
80101719:	ff 75 ec             	pushl  -0x14(%ebp)
8010171c:	e8 77 3c 00 00       	call   80105398 <memset>
80101721:	83 c4 10             	add    $0x10,%esp
      dip->type = type;
80101724:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101727:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
8010172b:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
8010172e:	83 ec 0c             	sub    $0xc,%esp
80101731:	ff 75 f0             	pushl  -0x10(%ebp)
80101734:	e8 4c 20 00 00       	call   80103785 <log_write>
80101739:	83 c4 10             	add    $0x10,%esp
      brelse(bp);
8010173c:	83 ec 0c             	sub    $0xc,%esp
8010173f:	ff 75 f0             	pushl  -0x10(%ebp)
80101742:	e8 e7 ea ff ff       	call   8010022e <brelse>
80101747:	83 c4 10             	add    $0x10,%esp
      return iget(dev, inum);
8010174a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010174d:	83 ec 08             	sub    $0x8,%esp
80101750:	50                   	push   %eax
80101751:	ff 75 08             	pushl  0x8(%ebp)
80101754:	e8 f8 00 00 00       	call   80101851 <iget>
80101759:	83 c4 10             	add    $0x10,%esp
8010175c:	eb 30                	jmp    8010178e <ialloc+0xd5>
    }
    brelse(bp);
8010175e:	83 ec 0c             	sub    $0xc,%esp
80101761:	ff 75 f0             	pushl  -0x10(%ebp)
80101764:	e8 c5 ea ff ff       	call   8010022e <brelse>
80101769:	83 c4 10             	add    $0x10,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
8010176c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101770:	8b 15 28 12 11 80    	mov    0x80111228,%edx
80101776:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101779:	39 c2                	cmp    %eax,%edx
8010177b:	0f 87 51 ff ff ff    	ja     801016d2 <ialloc+0x19>
  }
  panic("ialloc: no inodes");
80101781:	83 ec 0c             	sub    $0xc,%esp
80101784:	68 9b 87 10 80       	push   $0x8010879b
80101789:	e8 d8 ed ff ff       	call   80100566 <panic>
}
8010178e:	c9                   	leave  
8010178f:	c3                   	ret    

80101790 <iupdate>:

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
80101790:	55                   	push   %ebp
80101791:	89 e5                	mov    %esp,%ebp
80101793:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101796:	8b 45 08             	mov    0x8(%ebp),%eax
80101799:	8b 40 04             	mov    0x4(%eax),%eax
8010179c:	c1 e8 03             	shr    $0x3,%eax
8010179f:	89 c2                	mov    %eax,%edx
801017a1:	a1 34 12 11 80       	mov    0x80111234,%eax
801017a6:	01 c2                	add    %eax,%edx
801017a8:	8b 45 08             	mov    0x8(%ebp),%eax
801017ab:	8b 00                	mov    (%eax),%eax
801017ad:	83 ec 08             	sub    $0x8,%esp
801017b0:	52                   	push   %edx
801017b1:	50                   	push   %eax
801017b2:	e8 ff e9 ff ff       	call   801001b6 <bread>
801017b7:	83 c4 10             	add    $0x10,%esp
801017ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801017bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017c0:	8d 50 18             	lea    0x18(%eax),%edx
801017c3:	8b 45 08             	mov    0x8(%ebp),%eax
801017c6:	8b 40 04             	mov    0x4(%eax),%eax
801017c9:	83 e0 07             	and    $0x7,%eax
801017cc:	c1 e0 06             	shl    $0x6,%eax
801017cf:	01 d0                	add    %edx,%eax
801017d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
801017d4:	8b 45 08             	mov    0x8(%ebp),%eax
801017d7:	0f b7 50 10          	movzwl 0x10(%eax),%edx
801017db:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017de:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801017e1:	8b 45 08             	mov    0x8(%ebp),%eax
801017e4:	0f b7 50 12          	movzwl 0x12(%eax),%edx
801017e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017eb:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
801017ef:	8b 45 08             	mov    0x8(%ebp),%eax
801017f2:	0f b7 50 14          	movzwl 0x14(%eax),%edx
801017f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017f9:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
801017fd:	8b 45 08             	mov    0x8(%ebp),%eax
80101800:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101804:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101807:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
8010180b:	8b 45 08             	mov    0x8(%ebp),%eax
8010180e:	8b 50 18             	mov    0x18(%eax),%edx
80101811:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101814:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101817:	8b 45 08             	mov    0x8(%ebp),%eax
8010181a:	8d 50 1c             	lea    0x1c(%eax),%edx
8010181d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101820:	83 c0 0c             	add    $0xc,%eax
80101823:	83 ec 04             	sub    $0x4,%esp
80101826:	6a 34                	push   $0x34
80101828:	52                   	push   %edx
80101829:	50                   	push   %eax
8010182a:	e8 28 3c 00 00       	call   80105457 <memmove>
8010182f:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
80101832:	83 ec 0c             	sub    $0xc,%esp
80101835:	ff 75 f4             	pushl  -0xc(%ebp)
80101838:	e8 48 1f 00 00       	call   80103785 <log_write>
8010183d:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101840:	83 ec 0c             	sub    $0xc,%esp
80101843:	ff 75 f4             	pushl  -0xc(%ebp)
80101846:	e8 e3 e9 ff ff       	call   8010022e <brelse>
8010184b:	83 c4 10             	add    $0x10,%esp
}
8010184e:	90                   	nop
8010184f:	c9                   	leave  
80101850:	c3                   	ret    

80101851 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101851:	55                   	push   %ebp
80101852:	89 e5                	mov    %esp,%ebp
80101854:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101857:	83 ec 0c             	sub    $0xc,%esp
8010185a:	68 40 12 11 80       	push   $0x80111240
8010185f:	e8 d1 38 00 00       	call   80105135 <acquire>
80101864:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
80101867:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010186e:	c7 45 f4 74 12 11 80 	movl   $0x80111274,-0xc(%ebp)
80101875:	eb 5d                	jmp    801018d4 <iget+0x83>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101877:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010187a:	8b 40 08             	mov    0x8(%eax),%eax
8010187d:	85 c0                	test   %eax,%eax
8010187f:	7e 39                	jle    801018ba <iget+0x69>
80101881:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101884:	8b 00                	mov    (%eax),%eax
80101886:	3b 45 08             	cmp    0x8(%ebp),%eax
80101889:	75 2f                	jne    801018ba <iget+0x69>
8010188b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010188e:	8b 40 04             	mov    0x4(%eax),%eax
80101891:	3b 45 0c             	cmp    0xc(%ebp),%eax
80101894:	75 24                	jne    801018ba <iget+0x69>
      ip->ref++;
80101896:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101899:	8b 40 08             	mov    0x8(%eax),%eax
8010189c:	8d 50 01             	lea    0x1(%eax),%edx
8010189f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018a2:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
801018a5:	83 ec 0c             	sub    $0xc,%esp
801018a8:	68 40 12 11 80       	push   $0x80111240
801018ad:	e8 ea 38 00 00       	call   8010519c <release>
801018b2:	83 c4 10             	add    $0x10,%esp
      return ip;
801018b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018b8:	eb 74                	jmp    8010192e <iget+0xdd>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801018ba:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801018be:	75 10                	jne    801018d0 <iget+0x7f>
801018c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018c3:	8b 40 08             	mov    0x8(%eax),%eax
801018c6:	85 c0                	test   %eax,%eax
801018c8:	75 06                	jne    801018d0 <iget+0x7f>
      empty = ip;
801018ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801018d0:	83 45 f4 50          	addl   $0x50,-0xc(%ebp)
801018d4:	81 7d f4 14 22 11 80 	cmpl   $0x80112214,-0xc(%ebp)
801018db:	72 9a                	jb     80101877 <iget+0x26>
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801018dd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801018e1:	75 0d                	jne    801018f0 <iget+0x9f>
    panic("iget: no inodes");
801018e3:	83 ec 0c             	sub    $0xc,%esp
801018e6:	68 ad 87 10 80       	push   $0x801087ad
801018eb:	e8 76 ec ff ff       	call   80100566 <panic>

  ip = empty;
801018f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
801018f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018f9:	8b 55 08             	mov    0x8(%ebp),%edx
801018fc:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
801018fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101901:	8b 55 0c             	mov    0xc(%ebp),%edx
80101904:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
80101907:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010190a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
80101911:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101914:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  release(&icache.lock);
8010191b:	83 ec 0c             	sub    $0xc,%esp
8010191e:	68 40 12 11 80       	push   $0x80111240
80101923:	e8 74 38 00 00       	call   8010519c <release>
80101928:	83 c4 10             	add    $0x10,%esp

  return ip;
8010192b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010192e:	c9                   	leave  
8010192f:	c3                   	ret    

80101930 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101930:	55                   	push   %ebp
80101931:	89 e5                	mov    %esp,%ebp
80101933:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
80101936:	83 ec 0c             	sub    $0xc,%esp
80101939:	68 40 12 11 80       	push   $0x80111240
8010193e:	e8 f2 37 00 00       	call   80105135 <acquire>
80101943:	83 c4 10             	add    $0x10,%esp
  ip->ref++;
80101946:	8b 45 08             	mov    0x8(%ebp),%eax
80101949:	8b 40 08             	mov    0x8(%eax),%eax
8010194c:	8d 50 01             	lea    0x1(%eax),%edx
8010194f:	8b 45 08             	mov    0x8(%ebp),%eax
80101952:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101955:	83 ec 0c             	sub    $0xc,%esp
80101958:	68 40 12 11 80       	push   $0x80111240
8010195d:	e8 3a 38 00 00       	call   8010519c <release>
80101962:	83 c4 10             	add    $0x10,%esp
  return ip;
80101965:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101968:	c9                   	leave  
80101969:	c3                   	ret    

8010196a <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
8010196a:	55                   	push   %ebp
8010196b:	89 e5                	mov    %esp,%ebp
8010196d:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101970:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101974:	74 0a                	je     80101980 <ilock+0x16>
80101976:	8b 45 08             	mov    0x8(%ebp),%eax
80101979:	8b 40 08             	mov    0x8(%eax),%eax
8010197c:	85 c0                	test   %eax,%eax
8010197e:	7f 0d                	jg     8010198d <ilock+0x23>
    panic("ilock");
80101980:	83 ec 0c             	sub    $0xc,%esp
80101983:	68 bd 87 10 80       	push   $0x801087bd
80101988:	e8 d9 eb ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
8010198d:	83 ec 0c             	sub    $0xc,%esp
80101990:	68 40 12 11 80       	push   $0x80111240
80101995:	e8 9b 37 00 00       	call   80105135 <acquire>
8010199a:	83 c4 10             	add    $0x10,%esp
  while(ip->flags & I_BUSY)
8010199d:	eb 13                	jmp    801019b2 <ilock+0x48>
    sleep(ip, &icache.lock);
8010199f:	83 ec 08             	sub    $0x8,%esp
801019a2:	68 40 12 11 80       	push   $0x80111240
801019a7:	ff 75 08             	pushl  0x8(%ebp)
801019aa:	e8 9b 34 00 00       	call   80104e4a <sleep>
801019af:	83 c4 10             	add    $0x10,%esp
  while(ip->flags & I_BUSY)
801019b2:	8b 45 08             	mov    0x8(%ebp),%eax
801019b5:	8b 40 0c             	mov    0xc(%eax),%eax
801019b8:	83 e0 01             	and    $0x1,%eax
801019bb:	85 c0                	test   %eax,%eax
801019bd:	75 e0                	jne    8010199f <ilock+0x35>
  ip->flags |= I_BUSY;
801019bf:	8b 45 08             	mov    0x8(%ebp),%eax
801019c2:	8b 40 0c             	mov    0xc(%eax),%eax
801019c5:	83 c8 01             	or     $0x1,%eax
801019c8:	89 c2                	mov    %eax,%edx
801019ca:	8b 45 08             	mov    0x8(%ebp),%eax
801019cd:	89 50 0c             	mov    %edx,0xc(%eax)
  release(&icache.lock);
801019d0:	83 ec 0c             	sub    $0xc,%esp
801019d3:	68 40 12 11 80       	push   $0x80111240
801019d8:	e8 bf 37 00 00       	call   8010519c <release>
801019dd:	83 c4 10             	add    $0x10,%esp

  if(!(ip->flags & I_VALID)){
801019e0:	8b 45 08             	mov    0x8(%ebp),%eax
801019e3:	8b 40 0c             	mov    0xc(%eax),%eax
801019e6:	83 e0 02             	and    $0x2,%eax
801019e9:	85 c0                	test   %eax,%eax
801019eb:	0f 85 d4 00 00 00    	jne    80101ac5 <ilock+0x15b>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801019f1:	8b 45 08             	mov    0x8(%ebp),%eax
801019f4:	8b 40 04             	mov    0x4(%eax),%eax
801019f7:	c1 e8 03             	shr    $0x3,%eax
801019fa:	89 c2                	mov    %eax,%edx
801019fc:	a1 34 12 11 80       	mov    0x80111234,%eax
80101a01:	01 c2                	add    %eax,%edx
80101a03:	8b 45 08             	mov    0x8(%ebp),%eax
80101a06:	8b 00                	mov    (%eax),%eax
80101a08:	83 ec 08             	sub    $0x8,%esp
80101a0b:	52                   	push   %edx
80101a0c:	50                   	push   %eax
80101a0d:	e8 a4 e7 ff ff       	call   801001b6 <bread>
80101a12:	83 c4 10             	add    $0x10,%esp
80101a15:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101a18:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a1b:	8d 50 18             	lea    0x18(%eax),%edx
80101a1e:	8b 45 08             	mov    0x8(%ebp),%eax
80101a21:	8b 40 04             	mov    0x4(%eax),%eax
80101a24:	83 e0 07             	and    $0x7,%eax
80101a27:	c1 e0 06             	shl    $0x6,%eax
80101a2a:	01 d0                	add    %edx,%eax
80101a2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
80101a2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a32:	0f b7 10             	movzwl (%eax),%edx
80101a35:	8b 45 08             	mov    0x8(%ebp),%eax
80101a38:	66 89 50 10          	mov    %dx,0x10(%eax)
    ip->major = dip->major;
80101a3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a3f:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80101a43:	8b 45 08             	mov    0x8(%ebp),%eax
80101a46:	66 89 50 12          	mov    %dx,0x12(%eax)
    ip->minor = dip->minor;
80101a4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a4d:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101a51:	8b 45 08             	mov    0x8(%ebp),%eax
80101a54:	66 89 50 14          	mov    %dx,0x14(%eax)
    ip->nlink = dip->nlink;
80101a58:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a5b:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80101a5f:	8b 45 08             	mov    0x8(%ebp),%eax
80101a62:	66 89 50 16          	mov    %dx,0x16(%eax)
    ip->size = dip->size;
80101a66:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a69:	8b 50 08             	mov    0x8(%eax),%edx
80101a6c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a6f:	89 50 18             	mov    %edx,0x18(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101a72:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a75:	8d 50 0c             	lea    0xc(%eax),%edx
80101a78:	8b 45 08             	mov    0x8(%ebp),%eax
80101a7b:	83 c0 1c             	add    $0x1c,%eax
80101a7e:	83 ec 04             	sub    $0x4,%esp
80101a81:	6a 34                	push   $0x34
80101a83:	52                   	push   %edx
80101a84:	50                   	push   %eax
80101a85:	e8 cd 39 00 00       	call   80105457 <memmove>
80101a8a:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101a8d:	83 ec 0c             	sub    $0xc,%esp
80101a90:	ff 75 f4             	pushl  -0xc(%ebp)
80101a93:	e8 96 e7 ff ff       	call   8010022e <brelse>
80101a98:	83 c4 10             	add    $0x10,%esp
    ip->flags |= I_VALID;
80101a9b:	8b 45 08             	mov    0x8(%ebp),%eax
80101a9e:	8b 40 0c             	mov    0xc(%eax),%eax
80101aa1:	83 c8 02             	or     $0x2,%eax
80101aa4:	89 c2                	mov    %eax,%edx
80101aa6:	8b 45 08             	mov    0x8(%ebp),%eax
80101aa9:	89 50 0c             	mov    %edx,0xc(%eax)
    if(ip->type == 0)
80101aac:	8b 45 08             	mov    0x8(%ebp),%eax
80101aaf:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101ab3:	66 85 c0             	test   %ax,%ax
80101ab6:	75 0d                	jne    80101ac5 <ilock+0x15b>
      panic("ilock: no type");
80101ab8:	83 ec 0c             	sub    $0xc,%esp
80101abb:	68 c3 87 10 80       	push   $0x801087c3
80101ac0:	e8 a1 ea ff ff       	call   80100566 <panic>
  }
}
80101ac5:	90                   	nop
80101ac6:	c9                   	leave  
80101ac7:	c3                   	ret    

80101ac8 <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101ac8:	55                   	push   %ebp
80101ac9:	89 e5                	mov    %esp,%ebp
80101acb:	83 ec 08             	sub    $0x8,%esp
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
80101ace:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101ad2:	74 17                	je     80101aeb <iunlock+0x23>
80101ad4:	8b 45 08             	mov    0x8(%ebp),%eax
80101ad7:	8b 40 0c             	mov    0xc(%eax),%eax
80101ada:	83 e0 01             	and    $0x1,%eax
80101add:	85 c0                	test   %eax,%eax
80101adf:	74 0a                	je     80101aeb <iunlock+0x23>
80101ae1:	8b 45 08             	mov    0x8(%ebp),%eax
80101ae4:	8b 40 08             	mov    0x8(%eax),%eax
80101ae7:	85 c0                	test   %eax,%eax
80101ae9:	7f 0d                	jg     80101af8 <iunlock+0x30>
    panic("iunlock");
80101aeb:	83 ec 0c             	sub    $0xc,%esp
80101aee:	68 d2 87 10 80       	push   $0x801087d2
80101af3:	e8 6e ea ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
80101af8:	83 ec 0c             	sub    $0xc,%esp
80101afb:	68 40 12 11 80       	push   $0x80111240
80101b00:	e8 30 36 00 00       	call   80105135 <acquire>
80101b05:	83 c4 10             	add    $0x10,%esp
  ip->flags &= ~I_BUSY;
80101b08:	8b 45 08             	mov    0x8(%ebp),%eax
80101b0b:	8b 40 0c             	mov    0xc(%eax),%eax
80101b0e:	83 e0 fe             	and    $0xfffffffe,%eax
80101b11:	89 c2                	mov    %eax,%edx
80101b13:	8b 45 08             	mov    0x8(%ebp),%eax
80101b16:	89 50 0c             	mov    %edx,0xc(%eax)
  wakeup(ip);
80101b19:	83 ec 0c             	sub    $0xc,%esp
80101b1c:	ff 75 08             	pushl  0x8(%ebp)
80101b1f:	e8 11 34 00 00       	call   80104f35 <wakeup>
80101b24:	83 c4 10             	add    $0x10,%esp
  release(&icache.lock);
80101b27:	83 ec 0c             	sub    $0xc,%esp
80101b2a:	68 40 12 11 80       	push   $0x80111240
80101b2f:	e8 68 36 00 00       	call   8010519c <release>
80101b34:	83 c4 10             	add    $0x10,%esp
}
80101b37:	90                   	nop
80101b38:	c9                   	leave  
80101b39:	c3                   	ret    

80101b3a <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101b3a:	55                   	push   %ebp
80101b3b:	89 e5                	mov    %esp,%ebp
80101b3d:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
80101b40:	83 ec 0c             	sub    $0xc,%esp
80101b43:	68 40 12 11 80       	push   $0x80111240
80101b48:	e8 e8 35 00 00       	call   80105135 <acquire>
80101b4d:	83 c4 10             	add    $0x10,%esp
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101b50:	8b 45 08             	mov    0x8(%ebp),%eax
80101b53:	8b 40 08             	mov    0x8(%eax),%eax
80101b56:	83 f8 01             	cmp    $0x1,%eax
80101b59:	0f 85 a9 00 00 00    	jne    80101c08 <iput+0xce>
80101b5f:	8b 45 08             	mov    0x8(%ebp),%eax
80101b62:	8b 40 0c             	mov    0xc(%eax),%eax
80101b65:	83 e0 02             	and    $0x2,%eax
80101b68:	85 c0                	test   %eax,%eax
80101b6a:	0f 84 98 00 00 00    	je     80101c08 <iput+0xce>
80101b70:	8b 45 08             	mov    0x8(%ebp),%eax
80101b73:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80101b77:	66 85 c0             	test   %ax,%ax
80101b7a:	0f 85 88 00 00 00    	jne    80101c08 <iput+0xce>
    // inode has no links and no other references: truncate and free.
    if(ip->flags & I_BUSY)
80101b80:	8b 45 08             	mov    0x8(%ebp),%eax
80101b83:	8b 40 0c             	mov    0xc(%eax),%eax
80101b86:	83 e0 01             	and    $0x1,%eax
80101b89:	85 c0                	test   %eax,%eax
80101b8b:	74 0d                	je     80101b9a <iput+0x60>
      panic("iput busy");
80101b8d:	83 ec 0c             	sub    $0xc,%esp
80101b90:	68 da 87 10 80       	push   $0x801087da
80101b95:	e8 cc e9 ff ff       	call   80100566 <panic>
    ip->flags |= I_BUSY;
80101b9a:	8b 45 08             	mov    0x8(%ebp),%eax
80101b9d:	8b 40 0c             	mov    0xc(%eax),%eax
80101ba0:	83 c8 01             	or     $0x1,%eax
80101ba3:	89 c2                	mov    %eax,%edx
80101ba5:	8b 45 08             	mov    0x8(%ebp),%eax
80101ba8:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80101bab:	83 ec 0c             	sub    $0xc,%esp
80101bae:	68 40 12 11 80       	push   $0x80111240
80101bb3:	e8 e4 35 00 00       	call   8010519c <release>
80101bb8:	83 c4 10             	add    $0x10,%esp
    itrunc(ip);
80101bbb:	83 ec 0c             	sub    $0xc,%esp
80101bbe:	ff 75 08             	pushl  0x8(%ebp)
80101bc1:	e8 a8 01 00 00       	call   80101d6e <itrunc>
80101bc6:	83 c4 10             	add    $0x10,%esp
    ip->type = 0;
80101bc9:	8b 45 08             	mov    0x8(%ebp),%eax
80101bcc:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
    iupdate(ip);
80101bd2:	83 ec 0c             	sub    $0xc,%esp
80101bd5:	ff 75 08             	pushl  0x8(%ebp)
80101bd8:	e8 b3 fb ff ff       	call   80101790 <iupdate>
80101bdd:	83 c4 10             	add    $0x10,%esp
    acquire(&icache.lock);
80101be0:	83 ec 0c             	sub    $0xc,%esp
80101be3:	68 40 12 11 80       	push   $0x80111240
80101be8:	e8 48 35 00 00       	call   80105135 <acquire>
80101bed:	83 c4 10             	add    $0x10,%esp
    ip->flags = 0;
80101bf0:	8b 45 08             	mov    0x8(%ebp),%eax
80101bf3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101bfa:	83 ec 0c             	sub    $0xc,%esp
80101bfd:	ff 75 08             	pushl  0x8(%ebp)
80101c00:	e8 30 33 00 00       	call   80104f35 <wakeup>
80101c05:	83 c4 10             	add    $0x10,%esp
  }
  ip->ref--;
80101c08:	8b 45 08             	mov    0x8(%ebp),%eax
80101c0b:	8b 40 08             	mov    0x8(%eax),%eax
80101c0e:	8d 50 ff             	lea    -0x1(%eax),%edx
80101c11:	8b 45 08             	mov    0x8(%ebp),%eax
80101c14:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101c17:	83 ec 0c             	sub    $0xc,%esp
80101c1a:	68 40 12 11 80       	push   $0x80111240
80101c1f:	e8 78 35 00 00       	call   8010519c <release>
80101c24:	83 c4 10             	add    $0x10,%esp
}
80101c27:	90                   	nop
80101c28:	c9                   	leave  
80101c29:	c3                   	ret    

80101c2a <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101c2a:	55                   	push   %ebp
80101c2b:	89 e5                	mov    %esp,%ebp
80101c2d:	83 ec 08             	sub    $0x8,%esp
  iunlock(ip);
80101c30:	83 ec 0c             	sub    $0xc,%esp
80101c33:	ff 75 08             	pushl  0x8(%ebp)
80101c36:	e8 8d fe ff ff       	call   80101ac8 <iunlock>
80101c3b:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80101c3e:	83 ec 0c             	sub    $0xc,%esp
80101c41:	ff 75 08             	pushl  0x8(%ebp)
80101c44:	e8 f1 fe ff ff       	call   80101b3a <iput>
80101c49:	83 c4 10             	add    $0x10,%esp
}
80101c4c:	90                   	nop
80101c4d:	c9                   	leave  
80101c4e:	c3                   	ret    

80101c4f <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101c4f:	55                   	push   %ebp
80101c50:	89 e5                	mov    %esp,%ebp
80101c52:	53                   	push   %ebx
80101c53:	83 ec 14             	sub    $0x14,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101c56:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101c5a:	77 42                	ja     80101c9e <bmap+0x4f>
    if((addr = ip->addrs[bn]) == 0)
80101c5c:	8b 45 08             	mov    0x8(%ebp),%eax
80101c5f:	8b 55 0c             	mov    0xc(%ebp),%edx
80101c62:	83 c2 04             	add    $0x4,%edx
80101c65:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101c69:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c6c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101c70:	75 24                	jne    80101c96 <bmap+0x47>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101c72:	8b 45 08             	mov    0x8(%ebp),%eax
80101c75:	8b 00                	mov    (%eax),%eax
80101c77:	83 ec 0c             	sub    $0xc,%esp
80101c7a:	50                   	push   %eax
80101c7b:	e8 9a f7 ff ff       	call   8010141a <balloc>
80101c80:	83 c4 10             	add    $0x10,%esp
80101c83:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c86:	8b 45 08             	mov    0x8(%ebp),%eax
80101c89:	8b 55 0c             	mov    0xc(%ebp),%edx
80101c8c:	8d 4a 04             	lea    0x4(%edx),%ecx
80101c8f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c92:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101c96:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c99:	e9 cb 00 00 00       	jmp    80101d69 <bmap+0x11a>
  }
  bn -= NDIRECT;
80101c9e:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101ca2:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101ca6:	0f 87 b0 00 00 00    	ja     80101d5c <bmap+0x10d>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101cac:	8b 45 08             	mov    0x8(%ebp),%eax
80101caf:	8b 40 4c             	mov    0x4c(%eax),%eax
80101cb2:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101cb5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101cb9:	75 1d                	jne    80101cd8 <bmap+0x89>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101cbb:	8b 45 08             	mov    0x8(%ebp),%eax
80101cbe:	8b 00                	mov    (%eax),%eax
80101cc0:	83 ec 0c             	sub    $0xc,%esp
80101cc3:	50                   	push   %eax
80101cc4:	e8 51 f7 ff ff       	call   8010141a <balloc>
80101cc9:	83 c4 10             	add    $0x10,%esp
80101ccc:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101ccf:	8b 45 08             	mov    0x8(%ebp),%eax
80101cd2:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101cd5:	89 50 4c             	mov    %edx,0x4c(%eax)
    bp = bread(ip->dev, addr);
80101cd8:	8b 45 08             	mov    0x8(%ebp),%eax
80101cdb:	8b 00                	mov    (%eax),%eax
80101cdd:	83 ec 08             	sub    $0x8,%esp
80101ce0:	ff 75 f4             	pushl  -0xc(%ebp)
80101ce3:	50                   	push   %eax
80101ce4:	e8 cd e4 ff ff       	call   801001b6 <bread>
80101ce9:	83 c4 10             	add    $0x10,%esp
80101cec:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101cef:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101cf2:	83 c0 18             	add    $0x18,%eax
80101cf5:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101cf8:	8b 45 0c             	mov    0xc(%ebp),%eax
80101cfb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101d02:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d05:	01 d0                	add    %edx,%eax
80101d07:	8b 00                	mov    (%eax),%eax
80101d09:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d0c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101d10:	75 37                	jne    80101d49 <bmap+0xfa>
      a[bn] = addr = balloc(ip->dev);
80101d12:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d15:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101d1c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d1f:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80101d22:	8b 45 08             	mov    0x8(%ebp),%eax
80101d25:	8b 00                	mov    (%eax),%eax
80101d27:	83 ec 0c             	sub    $0xc,%esp
80101d2a:	50                   	push   %eax
80101d2b:	e8 ea f6 ff ff       	call   8010141a <balloc>
80101d30:	83 c4 10             	add    $0x10,%esp
80101d33:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d36:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d39:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101d3b:	83 ec 0c             	sub    $0xc,%esp
80101d3e:	ff 75 f0             	pushl  -0x10(%ebp)
80101d41:	e8 3f 1a 00 00       	call   80103785 <log_write>
80101d46:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101d49:	83 ec 0c             	sub    $0xc,%esp
80101d4c:	ff 75 f0             	pushl  -0x10(%ebp)
80101d4f:	e8 da e4 ff ff       	call   8010022e <brelse>
80101d54:	83 c4 10             	add    $0x10,%esp
    return addr;
80101d57:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d5a:	eb 0d                	jmp    80101d69 <bmap+0x11a>
  }

  panic("bmap: out of range");
80101d5c:	83 ec 0c             	sub    $0xc,%esp
80101d5f:	68 e4 87 10 80       	push   $0x801087e4
80101d64:	e8 fd e7 ff ff       	call   80100566 <panic>
}
80101d69:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101d6c:	c9                   	leave  
80101d6d:	c3                   	ret    

80101d6e <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101d6e:	55                   	push   %ebp
80101d6f:	89 e5                	mov    %esp,%ebp
80101d71:	83 ec 18             	sub    $0x18,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101d74:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101d7b:	eb 45                	jmp    80101dc2 <itrunc+0x54>
    if(ip->addrs[i]){
80101d7d:	8b 45 08             	mov    0x8(%ebp),%eax
80101d80:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d83:	83 c2 04             	add    $0x4,%edx
80101d86:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101d8a:	85 c0                	test   %eax,%eax
80101d8c:	74 30                	je     80101dbe <itrunc+0x50>
      bfree(ip->dev, ip->addrs[i]);
80101d8e:	8b 45 08             	mov    0x8(%ebp),%eax
80101d91:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d94:	83 c2 04             	add    $0x4,%edx
80101d97:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101d9b:	8b 55 08             	mov    0x8(%ebp),%edx
80101d9e:	8b 12                	mov    (%edx),%edx
80101da0:	83 ec 08             	sub    $0x8,%esp
80101da3:	50                   	push   %eax
80101da4:	52                   	push   %edx
80101da5:	e8 bc f7 ff ff       	call   80101566 <bfree>
80101daa:	83 c4 10             	add    $0x10,%esp
      ip->addrs[i] = 0;
80101dad:	8b 45 08             	mov    0x8(%ebp),%eax
80101db0:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101db3:	83 c2 04             	add    $0x4,%edx
80101db6:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101dbd:	00 
  for(i = 0; i < NDIRECT; i++){
80101dbe:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101dc2:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101dc6:	7e b5                	jle    80101d7d <itrunc+0xf>
    }
  }
  
  if(ip->addrs[NDIRECT]){
80101dc8:	8b 45 08             	mov    0x8(%ebp),%eax
80101dcb:	8b 40 4c             	mov    0x4c(%eax),%eax
80101dce:	85 c0                	test   %eax,%eax
80101dd0:	0f 84 a1 00 00 00    	je     80101e77 <itrunc+0x109>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101dd6:	8b 45 08             	mov    0x8(%ebp),%eax
80101dd9:	8b 50 4c             	mov    0x4c(%eax),%edx
80101ddc:	8b 45 08             	mov    0x8(%ebp),%eax
80101ddf:	8b 00                	mov    (%eax),%eax
80101de1:	83 ec 08             	sub    $0x8,%esp
80101de4:	52                   	push   %edx
80101de5:	50                   	push   %eax
80101de6:	e8 cb e3 ff ff       	call   801001b6 <bread>
80101deb:	83 c4 10             	add    $0x10,%esp
80101dee:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101df1:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101df4:	83 c0 18             	add    $0x18,%eax
80101df7:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101dfa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101e01:	eb 3c                	jmp    80101e3f <itrunc+0xd1>
      if(a[j])
80101e03:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e06:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101e0d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101e10:	01 d0                	add    %edx,%eax
80101e12:	8b 00                	mov    (%eax),%eax
80101e14:	85 c0                	test   %eax,%eax
80101e16:	74 23                	je     80101e3b <itrunc+0xcd>
        bfree(ip->dev, a[j]);
80101e18:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e1b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101e22:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101e25:	01 d0                	add    %edx,%eax
80101e27:	8b 00                	mov    (%eax),%eax
80101e29:	8b 55 08             	mov    0x8(%ebp),%edx
80101e2c:	8b 12                	mov    (%edx),%edx
80101e2e:	83 ec 08             	sub    $0x8,%esp
80101e31:	50                   	push   %eax
80101e32:	52                   	push   %edx
80101e33:	e8 2e f7 ff ff       	call   80101566 <bfree>
80101e38:	83 c4 10             	add    $0x10,%esp
    for(j = 0; j < NINDIRECT; j++){
80101e3b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101e3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e42:	83 f8 7f             	cmp    $0x7f,%eax
80101e45:	76 bc                	jbe    80101e03 <itrunc+0x95>
    }
    brelse(bp);
80101e47:	83 ec 0c             	sub    $0xc,%esp
80101e4a:	ff 75 ec             	pushl  -0x14(%ebp)
80101e4d:	e8 dc e3 ff ff       	call   8010022e <brelse>
80101e52:	83 c4 10             	add    $0x10,%esp
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101e55:	8b 45 08             	mov    0x8(%ebp),%eax
80101e58:	8b 40 4c             	mov    0x4c(%eax),%eax
80101e5b:	8b 55 08             	mov    0x8(%ebp),%edx
80101e5e:	8b 12                	mov    (%edx),%edx
80101e60:	83 ec 08             	sub    $0x8,%esp
80101e63:	50                   	push   %eax
80101e64:	52                   	push   %edx
80101e65:	e8 fc f6 ff ff       	call   80101566 <bfree>
80101e6a:	83 c4 10             	add    $0x10,%esp
    ip->addrs[NDIRECT] = 0;
80101e6d:	8b 45 08             	mov    0x8(%ebp),%eax
80101e70:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  }

  ip->size = 0;
80101e77:	8b 45 08             	mov    0x8(%ebp),%eax
80101e7a:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  iupdate(ip);
80101e81:	83 ec 0c             	sub    $0xc,%esp
80101e84:	ff 75 08             	pushl  0x8(%ebp)
80101e87:	e8 04 f9 ff ff       	call   80101790 <iupdate>
80101e8c:	83 c4 10             	add    $0x10,%esp
}
80101e8f:	90                   	nop
80101e90:	c9                   	leave  
80101e91:	c3                   	ret    

80101e92 <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101e92:	55                   	push   %ebp
80101e93:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101e95:	8b 45 08             	mov    0x8(%ebp),%eax
80101e98:	8b 00                	mov    (%eax),%eax
80101e9a:	89 c2                	mov    %eax,%edx
80101e9c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e9f:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101ea2:	8b 45 08             	mov    0x8(%ebp),%eax
80101ea5:	8b 50 04             	mov    0x4(%eax),%edx
80101ea8:	8b 45 0c             	mov    0xc(%ebp),%eax
80101eab:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101eae:	8b 45 08             	mov    0x8(%ebp),%eax
80101eb1:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101eb5:	8b 45 0c             	mov    0xc(%ebp),%eax
80101eb8:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80101ebb:	8b 45 08             	mov    0x8(%ebp),%eax
80101ebe:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101ec2:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ec5:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80101ec9:	8b 45 08             	mov    0x8(%ebp),%eax
80101ecc:	8b 50 18             	mov    0x18(%eax),%edx
80101ecf:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ed2:	89 50 10             	mov    %edx,0x10(%eax)
}
80101ed5:	90                   	nop
80101ed6:	5d                   	pop    %ebp
80101ed7:	c3                   	ret    

80101ed8 <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101ed8:	55                   	push   %ebp
80101ed9:	89 e5                	mov    %esp,%ebp
80101edb:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ede:	8b 45 08             	mov    0x8(%ebp),%eax
80101ee1:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101ee5:	66 83 f8 03          	cmp    $0x3,%ax
80101ee9:	75 5c                	jne    80101f47 <readi+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101eeb:	8b 45 08             	mov    0x8(%ebp),%eax
80101eee:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101ef2:	66 85 c0             	test   %ax,%ax
80101ef5:	78 20                	js     80101f17 <readi+0x3f>
80101ef7:	8b 45 08             	mov    0x8(%ebp),%eax
80101efa:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101efe:	66 83 f8 09          	cmp    $0x9,%ax
80101f02:	7f 13                	jg     80101f17 <readi+0x3f>
80101f04:	8b 45 08             	mov    0x8(%ebp),%eax
80101f07:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f0b:	98                   	cwtl   
80101f0c:	8b 04 c5 c0 11 11 80 	mov    -0x7feeee40(,%eax,8),%eax
80101f13:	85 c0                	test   %eax,%eax
80101f15:	75 0a                	jne    80101f21 <readi+0x49>
      return -1;
80101f17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f1c:	e9 0c 01 00 00       	jmp    8010202d <readi+0x155>
    return devsw[ip->major].read(ip, dst, n);
80101f21:	8b 45 08             	mov    0x8(%ebp),%eax
80101f24:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f28:	98                   	cwtl   
80101f29:	8b 04 c5 c0 11 11 80 	mov    -0x7feeee40(,%eax,8),%eax
80101f30:	8b 55 14             	mov    0x14(%ebp),%edx
80101f33:	83 ec 04             	sub    $0x4,%esp
80101f36:	52                   	push   %edx
80101f37:	ff 75 0c             	pushl  0xc(%ebp)
80101f3a:	ff 75 08             	pushl  0x8(%ebp)
80101f3d:	ff d0                	call   *%eax
80101f3f:	83 c4 10             	add    $0x10,%esp
80101f42:	e9 e6 00 00 00       	jmp    8010202d <readi+0x155>
  }

  if(off > ip->size || off + n < off)
80101f47:	8b 45 08             	mov    0x8(%ebp),%eax
80101f4a:	8b 40 18             	mov    0x18(%eax),%eax
80101f4d:	3b 45 10             	cmp    0x10(%ebp),%eax
80101f50:	72 0d                	jb     80101f5f <readi+0x87>
80101f52:	8b 55 10             	mov    0x10(%ebp),%edx
80101f55:	8b 45 14             	mov    0x14(%ebp),%eax
80101f58:	01 d0                	add    %edx,%eax
80101f5a:	3b 45 10             	cmp    0x10(%ebp),%eax
80101f5d:	73 0a                	jae    80101f69 <readi+0x91>
    return -1;
80101f5f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f64:	e9 c4 00 00 00       	jmp    8010202d <readi+0x155>
  if(off + n > ip->size)
80101f69:	8b 55 10             	mov    0x10(%ebp),%edx
80101f6c:	8b 45 14             	mov    0x14(%ebp),%eax
80101f6f:	01 c2                	add    %eax,%edx
80101f71:	8b 45 08             	mov    0x8(%ebp),%eax
80101f74:	8b 40 18             	mov    0x18(%eax),%eax
80101f77:	39 c2                	cmp    %eax,%edx
80101f79:	76 0c                	jbe    80101f87 <readi+0xaf>
    n = ip->size - off;
80101f7b:	8b 45 08             	mov    0x8(%ebp),%eax
80101f7e:	8b 40 18             	mov    0x18(%eax),%eax
80101f81:	2b 45 10             	sub    0x10(%ebp),%eax
80101f84:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101f87:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101f8e:	e9 8b 00 00 00       	jmp    8010201e <readi+0x146>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101f93:	8b 45 10             	mov    0x10(%ebp),%eax
80101f96:	c1 e8 09             	shr    $0x9,%eax
80101f99:	83 ec 08             	sub    $0x8,%esp
80101f9c:	50                   	push   %eax
80101f9d:	ff 75 08             	pushl  0x8(%ebp)
80101fa0:	e8 aa fc ff ff       	call   80101c4f <bmap>
80101fa5:	83 c4 10             	add    $0x10,%esp
80101fa8:	89 c2                	mov    %eax,%edx
80101faa:	8b 45 08             	mov    0x8(%ebp),%eax
80101fad:	8b 00                	mov    (%eax),%eax
80101faf:	83 ec 08             	sub    $0x8,%esp
80101fb2:	52                   	push   %edx
80101fb3:	50                   	push   %eax
80101fb4:	e8 fd e1 ff ff       	call   801001b6 <bread>
80101fb9:	83 c4 10             	add    $0x10,%esp
80101fbc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101fbf:	8b 45 10             	mov    0x10(%ebp),%eax
80101fc2:	25 ff 01 00 00       	and    $0x1ff,%eax
80101fc7:	ba 00 02 00 00       	mov    $0x200,%edx
80101fcc:	29 c2                	sub    %eax,%edx
80101fce:	8b 45 14             	mov    0x14(%ebp),%eax
80101fd1:	2b 45 f4             	sub    -0xc(%ebp),%eax
80101fd4:	39 c2                	cmp    %eax,%edx
80101fd6:	0f 46 c2             	cmovbe %edx,%eax
80101fd9:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
80101fdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101fdf:	8d 50 18             	lea    0x18(%eax),%edx
80101fe2:	8b 45 10             	mov    0x10(%ebp),%eax
80101fe5:	25 ff 01 00 00       	and    $0x1ff,%eax
80101fea:	01 d0                	add    %edx,%eax
80101fec:	83 ec 04             	sub    $0x4,%esp
80101fef:	ff 75 ec             	pushl  -0x14(%ebp)
80101ff2:	50                   	push   %eax
80101ff3:	ff 75 0c             	pushl  0xc(%ebp)
80101ff6:	e8 5c 34 00 00       	call   80105457 <memmove>
80101ffb:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101ffe:	83 ec 0c             	sub    $0xc,%esp
80102001:	ff 75 f0             	pushl  -0x10(%ebp)
80102004:	e8 25 e2 ff ff       	call   8010022e <brelse>
80102009:	83 c4 10             	add    $0x10,%esp
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010200c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010200f:	01 45 f4             	add    %eax,-0xc(%ebp)
80102012:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102015:	01 45 10             	add    %eax,0x10(%ebp)
80102018:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010201b:	01 45 0c             	add    %eax,0xc(%ebp)
8010201e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102021:	3b 45 14             	cmp    0x14(%ebp),%eax
80102024:	0f 82 69 ff ff ff    	jb     80101f93 <readi+0xbb>
  }
  return n;
8010202a:	8b 45 14             	mov    0x14(%ebp),%eax
}
8010202d:	c9                   	leave  
8010202e:	c3                   	ret    

8010202f <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
8010202f:	55                   	push   %ebp
80102030:	89 e5                	mov    %esp,%ebp
80102032:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80102035:	8b 45 08             	mov    0x8(%ebp),%eax
80102038:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010203c:	66 83 f8 03          	cmp    $0x3,%ax
80102040:	75 5c                	jne    8010209e <writei+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80102042:	8b 45 08             	mov    0x8(%ebp),%eax
80102045:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80102049:	66 85 c0             	test   %ax,%ax
8010204c:	78 20                	js     8010206e <writei+0x3f>
8010204e:	8b 45 08             	mov    0x8(%ebp),%eax
80102051:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80102055:	66 83 f8 09          	cmp    $0x9,%ax
80102059:	7f 13                	jg     8010206e <writei+0x3f>
8010205b:	8b 45 08             	mov    0x8(%ebp),%eax
8010205e:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80102062:	98                   	cwtl   
80102063:	8b 04 c5 c4 11 11 80 	mov    -0x7feeee3c(,%eax,8),%eax
8010206a:	85 c0                	test   %eax,%eax
8010206c:	75 0a                	jne    80102078 <writei+0x49>
      return -1;
8010206e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102073:	e9 3d 01 00 00       	jmp    801021b5 <writei+0x186>
    return devsw[ip->major].write(ip, src, n);
80102078:	8b 45 08             	mov    0x8(%ebp),%eax
8010207b:	0f b7 40 12          	movzwl 0x12(%eax),%eax
8010207f:	98                   	cwtl   
80102080:	8b 04 c5 c4 11 11 80 	mov    -0x7feeee3c(,%eax,8),%eax
80102087:	8b 55 14             	mov    0x14(%ebp),%edx
8010208a:	83 ec 04             	sub    $0x4,%esp
8010208d:	52                   	push   %edx
8010208e:	ff 75 0c             	pushl  0xc(%ebp)
80102091:	ff 75 08             	pushl  0x8(%ebp)
80102094:	ff d0                	call   *%eax
80102096:	83 c4 10             	add    $0x10,%esp
80102099:	e9 17 01 00 00       	jmp    801021b5 <writei+0x186>
  }

  if(off > ip->size || off + n < off)
8010209e:	8b 45 08             	mov    0x8(%ebp),%eax
801020a1:	8b 40 18             	mov    0x18(%eax),%eax
801020a4:	3b 45 10             	cmp    0x10(%ebp),%eax
801020a7:	72 0d                	jb     801020b6 <writei+0x87>
801020a9:	8b 55 10             	mov    0x10(%ebp),%edx
801020ac:	8b 45 14             	mov    0x14(%ebp),%eax
801020af:	01 d0                	add    %edx,%eax
801020b1:	3b 45 10             	cmp    0x10(%ebp),%eax
801020b4:	73 0a                	jae    801020c0 <writei+0x91>
    return -1;
801020b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020bb:	e9 f5 00 00 00       	jmp    801021b5 <writei+0x186>
  if(off + n > MAXFILE*BSIZE)
801020c0:	8b 55 10             	mov    0x10(%ebp),%edx
801020c3:	8b 45 14             	mov    0x14(%ebp),%eax
801020c6:	01 d0                	add    %edx,%eax
801020c8:	3d 00 18 01 00       	cmp    $0x11800,%eax
801020cd:	76 0a                	jbe    801020d9 <writei+0xaa>
    return -1;
801020cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020d4:	e9 dc 00 00 00       	jmp    801021b5 <writei+0x186>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801020d9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801020e0:	e9 99 00 00 00       	jmp    8010217e <writei+0x14f>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801020e5:	8b 45 10             	mov    0x10(%ebp),%eax
801020e8:	c1 e8 09             	shr    $0x9,%eax
801020eb:	83 ec 08             	sub    $0x8,%esp
801020ee:	50                   	push   %eax
801020ef:	ff 75 08             	pushl  0x8(%ebp)
801020f2:	e8 58 fb ff ff       	call   80101c4f <bmap>
801020f7:	83 c4 10             	add    $0x10,%esp
801020fa:	89 c2                	mov    %eax,%edx
801020fc:	8b 45 08             	mov    0x8(%ebp),%eax
801020ff:	8b 00                	mov    (%eax),%eax
80102101:	83 ec 08             	sub    $0x8,%esp
80102104:	52                   	push   %edx
80102105:	50                   	push   %eax
80102106:	e8 ab e0 ff ff       	call   801001b6 <bread>
8010210b:	83 c4 10             	add    $0x10,%esp
8010210e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80102111:	8b 45 10             	mov    0x10(%ebp),%eax
80102114:	25 ff 01 00 00       	and    $0x1ff,%eax
80102119:	ba 00 02 00 00       	mov    $0x200,%edx
8010211e:	29 c2                	sub    %eax,%edx
80102120:	8b 45 14             	mov    0x14(%ebp),%eax
80102123:	2b 45 f4             	sub    -0xc(%ebp),%eax
80102126:	39 c2                	cmp    %eax,%edx
80102128:	0f 46 c2             	cmovbe %edx,%eax
8010212b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
8010212e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102131:	8d 50 18             	lea    0x18(%eax),%edx
80102134:	8b 45 10             	mov    0x10(%ebp),%eax
80102137:	25 ff 01 00 00       	and    $0x1ff,%eax
8010213c:	01 d0                	add    %edx,%eax
8010213e:	83 ec 04             	sub    $0x4,%esp
80102141:	ff 75 ec             	pushl  -0x14(%ebp)
80102144:	ff 75 0c             	pushl  0xc(%ebp)
80102147:	50                   	push   %eax
80102148:	e8 0a 33 00 00       	call   80105457 <memmove>
8010214d:	83 c4 10             	add    $0x10,%esp
    log_write(bp);
80102150:	83 ec 0c             	sub    $0xc,%esp
80102153:	ff 75 f0             	pushl  -0x10(%ebp)
80102156:	e8 2a 16 00 00       	call   80103785 <log_write>
8010215b:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
8010215e:	83 ec 0c             	sub    $0xc,%esp
80102161:	ff 75 f0             	pushl  -0x10(%ebp)
80102164:	e8 c5 e0 ff ff       	call   8010022e <brelse>
80102169:	83 c4 10             	add    $0x10,%esp
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010216c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010216f:	01 45 f4             	add    %eax,-0xc(%ebp)
80102172:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102175:	01 45 10             	add    %eax,0x10(%ebp)
80102178:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010217b:	01 45 0c             	add    %eax,0xc(%ebp)
8010217e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102181:	3b 45 14             	cmp    0x14(%ebp),%eax
80102184:	0f 82 5b ff ff ff    	jb     801020e5 <writei+0xb6>
  }

  if(n > 0 && off > ip->size){
8010218a:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
8010218e:	74 22                	je     801021b2 <writei+0x183>
80102190:	8b 45 08             	mov    0x8(%ebp),%eax
80102193:	8b 40 18             	mov    0x18(%eax),%eax
80102196:	3b 45 10             	cmp    0x10(%ebp),%eax
80102199:	73 17                	jae    801021b2 <writei+0x183>
    ip->size = off;
8010219b:	8b 45 08             	mov    0x8(%ebp),%eax
8010219e:	8b 55 10             	mov    0x10(%ebp),%edx
801021a1:	89 50 18             	mov    %edx,0x18(%eax)
    iupdate(ip);
801021a4:	83 ec 0c             	sub    $0xc,%esp
801021a7:	ff 75 08             	pushl  0x8(%ebp)
801021aa:	e8 e1 f5 ff ff       	call   80101790 <iupdate>
801021af:	83 c4 10             	add    $0x10,%esp
  }
  return n;
801021b2:	8b 45 14             	mov    0x14(%ebp),%eax
}
801021b5:	c9                   	leave  
801021b6:	c3                   	ret    

801021b7 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
801021b7:	55                   	push   %ebp
801021b8:	89 e5                	mov    %esp,%ebp
801021ba:	83 ec 08             	sub    $0x8,%esp
  return strncmp(s, t, DIRSIZ);
801021bd:	83 ec 04             	sub    $0x4,%esp
801021c0:	6a 0e                	push   $0xe
801021c2:	ff 75 0c             	pushl  0xc(%ebp)
801021c5:	ff 75 08             	pushl  0x8(%ebp)
801021c8:	e8 20 33 00 00       	call   801054ed <strncmp>
801021cd:	83 c4 10             	add    $0x10,%esp
}
801021d0:	c9                   	leave  
801021d1:	c3                   	ret    

801021d2 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
801021d2:	55                   	push   %ebp
801021d3:	89 e5                	mov    %esp,%ebp
801021d5:	83 ec 28             	sub    $0x28,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
801021d8:	8b 45 08             	mov    0x8(%ebp),%eax
801021db:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801021df:	66 83 f8 01          	cmp    $0x1,%ax
801021e3:	74 0d                	je     801021f2 <dirlookup+0x20>
    panic("dirlookup not DIR");
801021e5:	83 ec 0c             	sub    $0xc,%esp
801021e8:	68 f7 87 10 80       	push   $0x801087f7
801021ed:	e8 74 e3 ff ff       	call   80100566 <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
801021f2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801021f9:	eb 7b                	jmp    80102276 <dirlookup+0xa4>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801021fb:	6a 10                	push   $0x10
801021fd:	ff 75 f4             	pushl  -0xc(%ebp)
80102200:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102203:	50                   	push   %eax
80102204:	ff 75 08             	pushl  0x8(%ebp)
80102207:	e8 cc fc ff ff       	call   80101ed8 <readi>
8010220c:	83 c4 10             	add    $0x10,%esp
8010220f:	83 f8 10             	cmp    $0x10,%eax
80102212:	74 0d                	je     80102221 <dirlookup+0x4f>
      panic("dirlink read");
80102214:	83 ec 0c             	sub    $0xc,%esp
80102217:	68 09 88 10 80       	push   $0x80108809
8010221c:	e8 45 e3 ff ff       	call   80100566 <panic>
    if(de.inum == 0)
80102221:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102225:	66 85 c0             	test   %ax,%ax
80102228:	74 47                	je     80102271 <dirlookup+0x9f>
      continue;
    if(namecmp(name, de.name) == 0){
8010222a:	83 ec 08             	sub    $0x8,%esp
8010222d:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102230:	83 c0 02             	add    $0x2,%eax
80102233:	50                   	push   %eax
80102234:	ff 75 0c             	pushl  0xc(%ebp)
80102237:	e8 7b ff ff ff       	call   801021b7 <namecmp>
8010223c:	83 c4 10             	add    $0x10,%esp
8010223f:	85 c0                	test   %eax,%eax
80102241:	75 2f                	jne    80102272 <dirlookup+0xa0>
      // entry matches path element
      if(poff)
80102243:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80102247:	74 08                	je     80102251 <dirlookup+0x7f>
        *poff = off;
80102249:	8b 45 10             	mov    0x10(%ebp),%eax
8010224c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010224f:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
80102251:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102255:	0f b7 c0             	movzwl %ax,%eax
80102258:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
8010225b:	8b 45 08             	mov    0x8(%ebp),%eax
8010225e:	8b 00                	mov    (%eax),%eax
80102260:	83 ec 08             	sub    $0x8,%esp
80102263:	ff 75 f0             	pushl  -0x10(%ebp)
80102266:	50                   	push   %eax
80102267:	e8 e5 f5 ff ff       	call   80101851 <iget>
8010226c:	83 c4 10             	add    $0x10,%esp
8010226f:	eb 19                	jmp    8010228a <dirlookup+0xb8>
      continue;
80102271:	90                   	nop
  for(off = 0; off < dp->size; off += sizeof(de)){
80102272:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80102276:	8b 45 08             	mov    0x8(%ebp),%eax
80102279:	8b 40 18             	mov    0x18(%eax),%eax
8010227c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010227f:	0f 87 76 ff ff ff    	ja     801021fb <dirlookup+0x29>
    }
  }

  return 0;
80102285:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010228a:	c9                   	leave  
8010228b:	c3                   	ret    

8010228c <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
8010228c:	55                   	push   %ebp
8010228d:	89 e5                	mov    %esp,%ebp
8010228f:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80102292:	83 ec 04             	sub    $0x4,%esp
80102295:	6a 00                	push   $0x0
80102297:	ff 75 0c             	pushl  0xc(%ebp)
8010229a:	ff 75 08             	pushl  0x8(%ebp)
8010229d:	e8 30 ff ff ff       	call   801021d2 <dirlookup>
801022a2:	83 c4 10             	add    $0x10,%esp
801022a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
801022a8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801022ac:	74 18                	je     801022c6 <dirlink+0x3a>
    iput(ip);
801022ae:	83 ec 0c             	sub    $0xc,%esp
801022b1:	ff 75 f0             	pushl  -0x10(%ebp)
801022b4:	e8 81 f8 ff ff       	call   80101b3a <iput>
801022b9:	83 c4 10             	add    $0x10,%esp
    return -1;
801022bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801022c1:	e9 9c 00 00 00       	jmp    80102362 <dirlink+0xd6>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
801022c6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801022cd:	eb 39                	jmp    80102308 <dirlink+0x7c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801022cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022d2:	6a 10                	push   $0x10
801022d4:	50                   	push   %eax
801022d5:	8d 45 e0             	lea    -0x20(%ebp),%eax
801022d8:	50                   	push   %eax
801022d9:	ff 75 08             	pushl  0x8(%ebp)
801022dc:	e8 f7 fb ff ff       	call   80101ed8 <readi>
801022e1:	83 c4 10             	add    $0x10,%esp
801022e4:	83 f8 10             	cmp    $0x10,%eax
801022e7:	74 0d                	je     801022f6 <dirlink+0x6a>
      panic("dirlink read");
801022e9:	83 ec 0c             	sub    $0xc,%esp
801022ec:	68 09 88 10 80       	push   $0x80108809
801022f1:	e8 70 e2 ff ff       	call   80100566 <panic>
    if(de.inum == 0)
801022f6:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801022fa:	66 85 c0             	test   %ax,%ax
801022fd:	74 18                	je     80102317 <dirlink+0x8b>
  for(off = 0; off < dp->size; off += sizeof(de)){
801022ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102302:	83 c0 10             	add    $0x10,%eax
80102305:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102308:	8b 45 08             	mov    0x8(%ebp),%eax
8010230b:	8b 50 18             	mov    0x18(%eax),%edx
8010230e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102311:	39 c2                	cmp    %eax,%edx
80102313:	77 ba                	ja     801022cf <dirlink+0x43>
80102315:	eb 01                	jmp    80102318 <dirlink+0x8c>
      break;
80102317:	90                   	nop
  }

  strncpy(de.name, name, DIRSIZ);
80102318:	83 ec 04             	sub    $0x4,%esp
8010231b:	6a 0e                	push   $0xe
8010231d:	ff 75 0c             	pushl  0xc(%ebp)
80102320:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102323:	83 c0 02             	add    $0x2,%eax
80102326:	50                   	push   %eax
80102327:	e8 17 32 00 00       	call   80105543 <strncpy>
8010232c:	83 c4 10             	add    $0x10,%esp
  de.inum = inum;
8010232f:	8b 45 10             	mov    0x10(%ebp),%eax
80102332:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102336:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102339:	6a 10                	push   $0x10
8010233b:	50                   	push   %eax
8010233c:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010233f:	50                   	push   %eax
80102340:	ff 75 08             	pushl  0x8(%ebp)
80102343:	e8 e7 fc ff ff       	call   8010202f <writei>
80102348:	83 c4 10             	add    $0x10,%esp
8010234b:	83 f8 10             	cmp    $0x10,%eax
8010234e:	74 0d                	je     8010235d <dirlink+0xd1>
    panic("dirlink");
80102350:	83 ec 0c             	sub    $0xc,%esp
80102353:	68 16 88 10 80       	push   $0x80108816
80102358:	e8 09 e2 ff ff       	call   80100566 <panic>
  
  return 0;
8010235d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102362:	c9                   	leave  
80102363:	c3                   	ret    

80102364 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
80102364:	55                   	push   %ebp
80102365:	89 e5                	mov    %esp,%ebp
80102367:	83 ec 18             	sub    $0x18,%esp
  char *s;
  int len;

  while(*path == '/')
8010236a:	eb 04                	jmp    80102370 <skipelem+0xc>
    path++;
8010236c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
80102370:	8b 45 08             	mov    0x8(%ebp),%eax
80102373:	0f b6 00             	movzbl (%eax),%eax
80102376:	3c 2f                	cmp    $0x2f,%al
80102378:	74 f2                	je     8010236c <skipelem+0x8>
  if(*path == 0)
8010237a:	8b 45 08             	mov    0x8(%ebp),%eax
8010237d:	0f b6 00             	movzbl (%eax),%eax
80102380:	84 c0                	test   %al,%al
80102382:	75 07                	jne    8010238b <skipelem+0x27>
    return 0;
80102384:	b8 00 00 00 00       	mov    $0x0,%eax
80102389:	eb 7b                	jmp    80102406 <skipelem+0xa2>
  s = path;
8010238b:	8b 45 08             	mov    0x8(%ebp),%eax
8010238e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
80102391:	eb 04                	jmp    80102397 <skipelem+0x33>
    path++;
80102393:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path != '/' && *path != 0)
80102397:	8b 45 08             	mov    0x8(%ebp),%eax
8010239a:	0f b6 00             	movzbl (%eax),%eax
8010239d:	3c 2f                	cmp    $0x2f,%al
8010239f:	74 0a                	je     801023ab <skipelem+0x47>
801023a1:	8b 45 08             	mov    0x8(%ebp),%eax
801023a4:	0f b6 00             	movzbl (%eax),%eax
801023a7:	84 c0                	test   %al,%al
801023a9:	75 e8                	jne    80102393 <skipelem+0x2f>
  len = path - s;
801023ab:	8b 55 08             	mov    0x8(%ebp),%edx
801023ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023b1:	29 c2                	sub    %eax,%edx
801023b3:	89 d0                	mov    %edx,%eax
801023b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
801023b8:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
801023bc:	7e 15                	jle    801023d3 <skipelem+0x6f>
    memmove(name, s, DIRSIZ);
801023be:	83 ec 04             	sub    $0x4,%esp
801023c1:	6a 0e                	push   $0xe
801023c3:	ff 75 f4             	pushl  -0xc(%ebp)
801023c6:	ff 75 0c             	pushl  0xc(%ebp)
801023c9:	e8 89 30 00 00       	call   80105457 <memmove>
801023ce:	83 c4 10             	add    $0x10,%esp
801023d1:	eb 26                	jmp    801023f9 <skipelem+0x95>
  else {
    memmove(name, s, len);
801023d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801023d6:	83 ec 04             	sub    $0x4,%esp
801023d9:	50                   	push   %eax
801023da:	ff 75 f4             	pushl  -0xc(%ebp)
801023dd:	ff 75 0c             	pushl  0xc(%ebp)
801023e0:	e8 72 30 00 00       	call   80105457 <memmove>
801023e5:	83 c4 10             	add    $0x10,%esp
    name[len] = 0;
801023e8:	8b 55 f0             	mov    -0x10(%ebp),%edx
801023eb:	8b 45 0c             	mov    0xc(%ebp),%eax
801023ee:	01 d0                	add    %edx,%eax
801023f0:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
801023f3:	eb 04                	jmp    801023f9 <skipelem+0x95>
    path++;
801023f5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
801023f9:	8b 45 08             	mov    0x8(%ebp),%eax
801023fc:	0f b6 00             	movzbl (%eax),%eax
801023ff:	3c 2f                	cmp    $0x2f,%al
80102401:	74 f2                	je     801023f5 <skipelem+0x91>
  return path;
80102403:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102406:	c9                   	leave  
80102407:	c3                   	ret    

80102408 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102408:	55                   	push   %ebp
80102409:	89 e5                	mov    %esp,%ebp
8010240b:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *next;

  if(*path == '/')
8010240e:	8b 45 08             	mov    0x8(%ebp),%eax
80102411:	0f b6 00             	movzbl (%eax),%eax
80102414:	3c 2f                	cmp    $0x2f,%al
80102416:	75 17                	jne    8010242f <namex+0x27>
    ip = iget(ROOTDEV, ROOTINO);
80102418:	83 ec 08             	sub    $0x8,%esp
8010241b:	6a 01                	push   $0x1
8010241d:	6a 01                	push   $0x1
8010241f:	e8 2d f4 ff ff       	call   80101851 <iget>
80102424:	83 c4 10             	add    $0x10,%esp
80102427:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010242a:	e9 bb 00 00 00       	jmp    801024ea <namex+0xe2>
  else
    ip = idup(proc->cwd);
8010242f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80102435:	8b 40 68             	mov    0x68(%eax),%eax
80102438:	83 ec 0c             	sub    $0xc,%esp
8010243b:	50                   	push   %eax
8010243c:	e8 ef f4 ff ff       	call   80101930 <idup>
80102441:	83 c4 10             	add    $0x10,%esp
80102444:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
80102447:	e9 9e 00 00 00       	jmp    801024ea <namex+0xe2>
    ilock(ip);
8010244c:	83 ec 0c             	sub    $0xc,%esp
8010244f:	ff 75 f4             	pushl  -0xc(%ebp)
80102452:	e8 13 f5 ff ff       	call   8010196a <ilock>
80102457:	83 c4 10             	add    $0x10,%esp
    if(ip->type != T_DIR){
8010245a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010245d:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80102461:	66 83 f8 01          	cmp    $0x1,%ax
80102465:	74 18                	je     8010247f <namex+0x77>
      iunlockput(ip);
80102467:	83 ec 0c             	sub    $0xc,%esp
8010246a:	ff 75 f4             	pushl  -0xc(%ebp)
8010246d:	e8 b8 f7 ff ff       	call   80101c2a <iunlockput>
80102472:	83 c4 10             	add    $0x10,%esp
      return 0;
80102475:	b8 00 00 00 00       	mov    $0x0,%eax
8010247a:	e9 a7 00 00 00       	jmp    80102526 <namex+0x11e>
    }
    if(nameiparent && *path == '\0'){
8010247f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102483:	74 20                	je     801024a5 <namex+0x9d>
80102485:	8b 45 08             	mov    0x8(%ebp),%eax
80102488:	0f b6 00             	movzbl (%eax),%eax
8010248b:	84 c0                	test   %al,%al
8010248d:	75 16                	jne    801024a5 <namex+0x9d>
      // Stop one level early.
      iunlock(ip);
8010248f:	83 ec 0c             	sub    $0xc,%esp
80102492:	ff 75 f4             	pushl  -0xc(%ebp)
80102495:	e8 2e f6 ff ff       	call   80101ac8 <iunlock>
8010249a:	83 c4 10             	add    $0x10,%esp
      return ip;
8010249d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801024a0:	e9 81 00 00 00       	jmp    80102526 <namex+0x11e>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
801024a5:	83 ec 04             	sub    $0x4,%esp
801024a8:	6a 00                	push   $0x0
801024aa:	ff 75 10             	pushl  0x10(%ebp)
801024ad:	ff 75 f4             	pushl  -0xc(%ebp)
801024b0:	e8 1d fd ff ff       	call   801021d2 <dirlookup>
801024b5:	83 c4 10             	add    $0x10,%esp
801024b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
801024bb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801024bf:	75 15                	jne    801024d6 <namex+0xce>
      iunlockput(ip);
801024c1:	83 ec 0c             	sub    $0xc,%esp
801024c4:	ff 75 f4             	pushl  -0xc(%ebp)
801024c7:	e8 5e f7 ff ff       	call   80101c2a <iunlockput>
801024cc:	83 c4 10             	add    $0x10,%esp
      return 0;
801024cf:	b8 00 00 00 00       	mov    $0x0,%eax
801024d4:	eb 50                	jmp    80102526 <namex+0x11e>
    }
    iunlockput(ip);
801024d6:	83 ec 0c             	sub    $0xc,%esp
801024d9:	ff 75 f4             	pushl  -0xc(%ebp)
801024dc:	e8 49 f7 ff ff       	call   80101c2a <iunlockput>
801024e1:	83 c4 10             	add    $0x10,%esp
    ip = next;
801024e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801024e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while((path = skipelem(path, name)) != 0){
801024ea:	83 ec 08             	sub    $0x8,%esp
801024ed:	ff 75 10             	pushl  0x10(%ebp)
801024f0:	ff 75 08             	pushl  0x8(%ebp)
801024f3:	e8 6c fe ff ff       	call   80102364 <skipelem>
801024f8:	83 c4 10             	add    $0x10,%esp
801024fb:	89 45 08             	mov    %eax,0x8(%ebp)
801024fe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102502:	0f 85 44 ff ff ff    	jne    8010244c <namex+0x44>
  }
  if(nameiparent){
80102508:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010250c:	74 15                	je     80102523 <namex+0x11b>
    iput(ip);
8010250e:	83 ec 0c             	sub    $0xc,%esp
80102511:	ff 75 f4             	pushl  -0xc(%ebp)
80102514:	e8 21 f6 ff ff       	call   80101b3a <iput>
80102519:	83 c4 10             	add    $0x10,%esp
    return 0;
8010251c:	b8 00 00 00 00       	mov    $0x0,%eax
80102521:	eb 03                	jmp    80102526 <namex+0x11e>
  }
  return ip;
80102523:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102526:	c9                   	leave  
80102527:	c3                   	ret    

80102528 <namei>:

struct inode*
namei(char *path)
{
80102528:	55                   	push   %ebp
80102529:	89 e5                	mov    %esp,%ebp
8010252b:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
8010252e:	83 ec 04             	sub    $0x4,%esp
80102531:	8d 45 ea             	lea    -0x16(%ebp),%eax
80102534:	50                   	push   %eax
80102535:	6a 00                	push   $0x0
80102537:	ff 75 08             	pushl  0x8(%ebp)
8010253a:	e8 c9 fe ff ff       	call   80102408 <namex>
8010253f:	83 c4 10             	add    $0x10,%esp
}
80102542:	c9                   	leave  
80102543:	c3                   	ret    

80102544 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102544:	55                   	push   %ebp
80102545:	89 e5                	mov    %esp,%ebp
80102547:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
8010254a:	83 ec 04             	sub    $0x4,%esp
8010254d:	ff 75 0c             	pushl  0xc(%ebp)
80102550:	6a 01                	push   $0x1
80102552:	ff 75 08             	pushl  0x8(%ebp)
80102555:	e8 ae fe ff ff       	call   80102408 <namex>
8010255a:	83 c4 10             	add    $0x10,%esp
}
8010255d:	c9                   	leave  
8010255e:	c3                   	ret    

8010255f <inb>:
{
8010255f:	55                   	push   %ebp
80102560:	89 e5                	mov    %esp,%ebp
80102562:	83 ec 14             	sub    $0x14,%esp
80102565:	8b 45 08             	mov    0x8(%ebp),%eax
80102568:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010256c:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102570:	89 c2                	mov    %eax,%edx
80102572:	ec                   	in     (%dx),%al
80102573:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102576:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
8010257a:	c9                   	leave  
8010257b:	c3                   	ret    

8010257c <insl>:
{
8010257c:	55                   	push   %ebp
8010257d:	89 e5                	mov    %esp,%ebp
8010257f:	57                   	push   %edi
80102580:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
80102581:	8b 55 08             	mov    0x8(%ebp),%edx
80102584:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102587:	8b 45 10             	mov    0x10(%ebp),%eax
8010258a:	89 cb                	mov    %ecx,%ebx
8010258c:	89 df                	mov    %ebx,%edi
8010258e:	89 c1                	mov    %eax,%ecx
80102590:	fc                   	cld    
80102591:	f3 6d                	rep insl (%dx),%es:(%edi)
80102593:	89 c8                	mov    %ecx,%eax
80102595:	89 fb                	mov    %edi,%ebx
80102597:	89 5d 0c             	mov    %ebx,0xc(%ebp)
8010259a:	89 45 10             	mov    %eax,0x10(%ebp)
}
8010259d:	90                   	nop
8010259e:	5b                   	pop    %ebx
8010259f:	5f                   	pop    %edi
801025a0:	5d                   	pop    %ebp
801025a1:	c3                   	ret    

801025a2 <outb>:
{
801025a2:	55                   	push   %ebp
801025a3:	89 e5                	mov    %esp,%ebp
801025a5:	83 ec 08             	sub    $0x8,%esp
801025a8:	8b 55 08             	mov    0x8(%ebp),%edx
801025ab:	8b 45 0c             	mov    0xc(%ebp),%eax
801025ae:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801025b2:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801025b5:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801025b9:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801025bd:	ee                   	out    %al,(%dx)
}
801025be:	90                   	nop
801025bf:	c9                   	leave  
801025c0:	c3                   	ret    

801025c1 <outsl>:
{
801025c1:	55                   	push   %ebp
801025c2:	89 e5                	mov    %esp,%ebp
801025c4:	56                   	push   %esi
801025c5:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
801025c6:	8b 55 08             	mov    0x8(%ebp),%edx
801025c9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801025cc:	8b 45 10             	mov    0x10(%ebp),%eax
801025cf:	89 cb                	mov    %ecx,%ebx
801025d1:	89 de                	mov    %ebx,%esi
801025d3:	89 c1                	mov    %eax,%ecx
801025d5:	fc                   	cld    
801025d6:	f3 6f                	rep outsl %ds:(%esi),(%dx)
801025d8:	89 c8                	mov    %ecx,%eax
801025da:	89 f3                	mov    %esi,%ebx
801025dc:	89 5d 0c             	mov    %ebx,0xc(%ebp)
801025df:	89 45 10             	mov    %eax,0x10(%ebp)
}
801025e2:	90                   	nop
801025e3:	5b                   	pop    %ebx
801025e4:	5e                   	pop    %esi
801025e5:	5d                   	pop    %ebp
801025e6:	c3                   	ret    

801025e7 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
801025e7:	55                   	push   %ebp
801025e8:	89 e5                	mov    %esp,%ebp
801025ea:	83 ec 10             	sub    $0x10,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
801025ed:	90                   	nop
801025ee:	68 f7 01 00 00       	push   $0x1f7
801025f3:	e8 67 ff ff ff       	call   8010255f <inb>
801025f8:	83 c4 04             	add    $0x4,%esp
801025fb:	0f b6 c0             	movzbl %al,%eax
801025fe:	89 45 fc             	mov    %eax,-0x4(%ebp)
80102601:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102604:	25 c0 00 00 00       	and    $0xc0,%eax
80102609:	83 f8 40             	cmp    $0x40,%eax
8010260c:	75 e0                	jne    801025ee <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010260e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102612:	74 11                	je     80102625 <idewait+0x3e>
80102614:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102617:	83 e0 21             	and    $0x21,%eax
8010261a:	85 c0                	test   %eax,%eax
8010261c:	74 07                	je     80102625 <idewait+0x3e>
    return -1;
8010261e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102623:	eb 05                	jmp    8010262a <idewait+0x43>
  return 0;
80102625:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010262a:	c9                   	leave  
8010262b:	c3                   	ret    

8010262c <ideinit>:

void
ideinit(void)
{
8010262c:	55                   	push   %ebp
8010262d:	89 e5                	mov    %esp,%ebp
8010262f:	83 ec 18             	sub    $0x18,%esp
  int i;
  
  initlock(&idelock, "ide");
80102632:	83 ec 08             	sub    $0x8,%esp
80102635:	68 1e 88 10 80       	push   $0x8010881e
8010263a:	68 00 b6 10 80       	push   $0x8010b600
8010263f:	e8 cf 2a 00 00       	call   80105113 <initlock>
80102644:	83 c4 10             	add    $0x10,%esp
  picenable(IRQ_IDE);
80102647:	83 ec 0c             	sub    $0xc,%esp
8010264a:	6a 0e                	push   $0xe
8010264c:	e8 da 18 00 00       	call   80103f2b <picenable>
80102651:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_IDE, ncpu - 1);
80102654:	a1 40 29 11 80       	mov    0x80112940,%eax
80102659:	83 e8 01             	sub    $0x1,%eax
8010265c:	83 ec 08             	sub    $0x8,%esp
8010265f:	50                   	push   %eax
80102660:	6a 0e                	push   $0xe
80102662:	e8 73 04 00 00       	call   80102ada <ioapicenable>
80102667:	83 c4 10             	add    $0x10,%esp
  idewait(0);
8010266a:	83 ec 0c             	sub    $0xc,%esp
8010266d:	6a 00                	push   $0x0
8010266f:	e8 73 ff ff ff       	call   801025e7 <idewait>
80102674:	83 c4 10             	add    $0x10,%esp
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
80102677:	83 ec 08             	sub    $0x8,%esp
8010267a:	68 f0 00 00 00       	push   $0xf0
8010267f:	68 f6 01 00 00       	push   $0x1f6
80102684:	e8 19 ff ff ff       	call   801025a2 <outb>
80102689:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<1000; i++){
8010268c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102693:	eb 24                	jmp    801026b9 <ideinit+0x8d>
    if(inb(0x1f7) != 0){
80102695:	83 ec 0c             	sub    $0xc,%esp
80102698:	68 f7 01 00 00       	push   $0x1f7
8010269d:	e8 bd fe ff ff       	call   8010255f <inb>
801026a2:	83 c4 10             	add    $0x10,%esp
801026a5:	84 c0                	test   %al,%al
801026a7:	74 0c                	je     801026b5 <ideinit+0x89>
      havedisk1 = 1;
801026a9:	c7 05 38 b6 10 80 01 	movl   $0x1,0x8010b638
801026b0:	00 00 00 
      break;
801026b3:	eb 0d                	jmp    801026c2 <ideinit+0x96>
  for(i=0; i<1000; i++){
801026b5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801026b9:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
801026c0:	7e d3                	jle    80102695 <ideinit+0x69>
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
801026c2:	83 ec 08             	sub    $0x8,%esp
801026c5:	68 e0 00 00 00       	push   $0xe0
801026ca:	68 f6 01 00 00       	push   $0x1f6
801026cf:	e8 ce fe ff ff       	call   801025a2 <outb>
801026d4:	83 c4 10             	add    $0x10,%esp
}
801026d7:	90                   	nop
801026d8:	c9                   	leave  
801026d9:	c3                   	ret    

801026da <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801026da:	55                   	push   %ebp
801026db:	89 e5                	mov    %esp,%ebp
801026dd:	83 ec 18             	sub    $0x18,%esp
  if(b == 0)
801026e0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801026e4:	75 0d                	jne    801026f3 <idestart+0x19>
    panic("idestart");
801026e6:	83 ec 0c             	sub    $0xc,%esp
801026e9:	68 22 88 10 80       	push   $0x80108822
801026ee:	e8 73 de ff ff       	call   80100566 <panic>
  if(b->blockno >= FSSIZE)
801026f3:	8b 45 08             	mov    0x8(%ebp),%eax
801026f6:	8b 40 08             	mov    0x8(%eax),%eax
801026f9:	3d e7 03 00 00       	cmp    $0x3e7,%eax
801026fe:	76 0d                	jbe    8010270d <idestart+0x33>
    panic("incorrect blockno");
80102700:	83 ec 0c             	sub    $0xc,%esp
80102703:	68 2b 88 10 80       	push   $0x8010882b
80102708:	e8 59 de ff ff       	call   80100566 <panic>
  int sector_per_block =  BSIZE/SECTOR_SIZE;
8010270d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  int sector = b->blockno * sector_per_block;
80102714:	8b 45 08             	mov    0x8(%ebp),%eax
80102717:	8b 50 08             	mov    0x8(%eax),%edx
8010271a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010271d:	0f af c2             	imul   %edx,%eax
80102720:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if (sector_per_block > 7) panic("idestart");
80102723:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
80102727:	7e 0d                	jle    80102736 <idestart+0x5c>
80102729:	83 ec 0c             	sub    $0xc,%esp
8010272c:	68 22 88 10 80       	push   $0x80108822
80102731:	e8 30 de ff ff       	call   80100566 <panic>
  
  idewait(0);
80102736:	83 ec 0c             	sub    $0xc,%esp
80102739:	6a 00                	push   $0x0
8010273b:	e8 a7 fe ff ff       	call   801025e7 <idewait>
80102740:	83 c4 10             	add    $0x10,%esp
  outb(0x3f6, 0);  // generate interrupt
80102743:	83 ec 08             	sub    $0x8,%esp
80102746:	6a 00                	push   $0x0
80102748:	68 f6 03 00 00       	push   $0x3f6
8010274d:	e8 50 fe ff ff       	call   801025a2 <outb>
80102752:	83 c4 10             	add    $0x10,%esp
  outb(0x1f2, sector_per_block);  // number of sectors
80102755:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102758:	0f b6 c0             	movzbl %al,%eax
8010275b:	83 ec 08             	sub    $0x8,%esp
8010275e:	50                   	push   %eax
8010275f:	68 f2 01 00 00       	push   $0x1f2
80102764:	e8 39 fe ff ff       	call   801025a2 <outb>
80102769:	83 c4 10             	add    $0x10,%esp
  outb(0x1f3, sector & 0xff);
8010276c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010276f:	0f b6 c0             	movzbl %al,%eax
80102772:	83 ec 08             	sub    $0x8,%esp
80102775:	50                   	push   %eax
80102776:	68 f3 01 00 00       	push   $0x1f3
8010277b:	e8 22 fe ff ff       	call   801025a2 <outb>
80102780:	83 c4 10             	add    $0x10,%esp
  outb(0x1f4, (sector >> 8) & 0xff);
80102783:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102786:	c1 f8 08             	sar    $0x8,%eax
80102789:	0f b6 c0             	movzbl %al,%eax
8010278c:	83 ec 08             	sub    $0x8,%esp
8010278f:	50                   	push   %eax
80102790:	68 f4 01 00 00       	push   $0x1f4
80102795:	e8 08 fe ff ff       	call   801025a2 <outb>
8010279a:	83 c4 10             	add    $0x10,%esp
  outb(0x1f5, (sector >> 16) & 0xff);
8010279d:	8b 45 f0             	mov    -0x10(%ebp),%eax
801027a0:	c1 f8 10             	sar    $0x10,%eax
801027a3:	0f b6 c0             	movzbl %al,%eax
801027a6:	83 ec 08             	sub    $0x8,%esp
801027a9:	50                   	push   %eax
801027aa:	68 f5 01 00 00       	push   $0x1f5
801027af:	e8 ee fd ff ff       	call   801025a2 <outb>
801027b4:	83 c4 10             	add    $0x10,%esp
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801027b7:	8b 45 08             	mov    0x8(%ebp),%eax
801027ba:	8b 40 04             	mov    0x4(%eax),%eax
801027bd:	c1 e0 04             	shl    $0x4,%eax
801027c0:	83 e0 10             	and    $0x10,%eax
801027c3:	89 c2                	mov    %eax,%edx
801027c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801027c8:	c1 f8 18             	sar    $0x18,%eax
801027cb:	83 e0 0f             	and    $0xf,%eax
801027ce:	09 d0                	or     %edx,%eax
801027d0:	83 c8 e0             	or     $0xffffffe0,%eax
801027d3:	0f b6 c0             	movzbl %al,%eax
801027d6:	83 ec 08             	sub    $0x8,%esp
801027d9:	50                   	push   %eax
801027da:	68 f6 01 00 00       	push   $0x1f6
801027df:	e8 be fd ff ff       	call   801025a2 <outb>
801027e4:	83 c4 10             	add    $0x10,%esp
  if(b->flags & B_DIRTY){
801027e7:	8b 45 08             	mov    0x8(%ebp),%eax
801027ea:	8b 00                	mov    (%eax),%eax
801027ec:	83 e0 04             	and    $0x4,%eax
801027ef:	85 c0                	test   %eax,%eax
801027f1:	74 30                	je     80102823 <idestart+0x149>
    outb(0x1f7, IDE_CMD_WRITE);
801027f3:	83 ec 08             	sub    $0x8,%esp
801027f6:	6a 30                	push   $0x30
801027f8:	68 f7 01 00 00       	push   $0x1f7
801027fd:	e8 a0 fd ff ff       	call   801025a2 <outb>
80102802:	83 c4 10             	add    $0x10,%esp
    outsl(0x1f0, b->data, BSIZE/4);
80102805:	8b 45 08             	mov    0x8(%ebp),%eax
80102808:	83 c0 18             	add    $0x18,%eax
8010280b:	83 ec 04             	sub    $0x4,%esp
8010280e:	68 80 00 00 00       	push   $0x80
80102813:	50                   	push   %eax
80102814:	68 f0 01 00 00       	push   $0x1f0
80102819:	e8 a3 fd ff ff       	call   801025c1 <outsl>
8010281e:	83 c4 10             	add    $0x10,%esp
  } else {
    outb(0x1f7, IDE_CMD_READ);
  }
}
80102821:	eb 12                	jmp    80102835 <idestart+0x15b>
    outb(0x1f7, IDE_CMD_READ);
80102823:	83 ec 08             	sub    $0x8,%esp
80102826:	6a 20                	push   $0x20
80102828:	68 f7 01 00 00       	push   $0x1f7
8010282d:	e8 70 fd ff ff       	call   801025a2 <outb>
80102832:	83 c4 10             	add    $0x10,%esp
}
80102835:	90                   	nop
80102836:	c9                   	leave  
80102837:	c3                   	ret    

80102838 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102838:	55                   	push   %ebp
80102839:	89 e5                	mov    %esp,%ebp
8010283b:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
8010283e:	83 ec 0c             	sub    $0xc,%esp
80102841:	68 00 b6 10 80       	push   $0x8010b600
80102846:	e8 ea 28 00 00       	call   80105135 <acquire>
8010284b:	83 c4 10             	add    $0x10,%esp
  if((b = idequeue) == 0){
8010284e:	a1 34 b6 10 80       	mov    0x8010b634,%eax
80102853:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102856:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010285a:	75 15                	jne    80102871 <ideintr+0x39>
    release(&idelock);
8010285c:	83 ec 0c             	sub    $0xc,%esp
8010285f:	68 00 b6 10 80       	push   $0x8010b600
80102864:	e8 33 29 00 00       	call   8010519c <release>
80102869:	83 c4 10             	add    $0x10,%esp
    // cprintf("spurious IDE interrupt\n");
    return;
8010286c:	e9 9a 00 00 00       	jmp    8010290b <ideintr+0xd3>
  }
  idequeue = b->qnext;
80102871:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102874:	8b 40 14             	mov    0x14(%eax),%eax
80102877:	a3 34 b6 10 80       	mov    %eax,0x8010b634

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
8010287c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010287f:	8b 00                	mov    (%eax),%eax
80102881:	83 e0 04             	and    $0x4,%eax
80102884:	85 c0                	test   %eax,%eax
80102886:	75 2d                	jne    801028b5 <ideintr+0x7d>
80102888:	83 ec 0c             	sub    $0xc,%esp
8010288b:	6a 01                	push   $0x1
8010288d:	e8 55 fd ff ff       	call   801025e7 <idewait>
80102892:	83 c4 10             	add    $0x10,%esp
80102895:	85 c0                	test   %eax,%eax
80102897:	78 1c                	js     801028b5 <ideintr+0x7d>
    insl(0x1f0, b->data, BSIZE/4);
80102899:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010289c:	83 c0 18             	add    $0x18,%eax
8010289f:	83 ec 04             	sub    $0x4,%esp
801028a2:	68 80 00 00 00       	push   $0x80
801028a7:	50                   	push   %eax
801028a8:	68 f0 01 00 00       	push   $0x1f0
801028ad:	e8 ca fc ff ff       	call   8010257c <insl>
801028b2:	83 c4 10             	add    $0x10,%esp
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
801028b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028b8:	8b 00                	mov    (%eax),%eax
801028ba:	83 c8 02             	or     $0x2,%eax
801028bd:	89 c2                	mov    %eax,%edx
801028bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028c2:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
801028c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028c7:	8b 00                	mov    (%eax),%eax
801028c9:	83 e0 fb             	and    $0xfffffffb,%eax
801028cc:	89 c2                	mov    %eax,%edx
801028ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028d1:	89 10                	mov    %edx,(%eax)
  wakeup(b);
801028d3:	83 ec 0c             	sub    $0xc,%esp
801028d6:	ff 75 f4             	pushl  -0xc(%ebp)
801028d9:	e8 57 26 00 00       	call   80104f35 <wakeup>
801028de:	83 c4 10             	add    $0x10,%esp
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
801028e1:	a1 34 b6 10 80       	mov    0x8010b634,%eax
801028e6:	85 c0                	test   %eax,%eax
801028e8:	74 11                	je     801028fb <ideintr+0xc3>
    idestart(idequeue);
801028ea:	a1 34 b6 10 80       	mov    0x8010b634,%eax
801028ef:	83 ec 0c             	sub    $0xc,%esp
801028f2:	50                   	push   %eax
801028f3:	e8 e2 fd ff ff       	call   801026da <idestart>
801028f8:	83 c4 10             	add    $0x10,%esp

  release(&idelock);
801028fb:	83 ec 0c             	sub    $0xc,%esp
801028fe:	68 00 b6 10 80       	push   $0x8010b600
80102903:	e8 94 28 00 00       	call   8010519c <release>
80102908:	83 c4 10             	add    $0x10,%esp
}
8010290b:	c9                   	leave  
8010290c:	c3                   	ret    

8010290d <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
8010290d:	55                   	push   %ebp
8010290e:	89 e5                	mov    %esp,%ebp
80102910:	83 ec 18             	sub    $0x18,%esp
  struct buf **pp;

  if(!(b->flags & B_BUSY))
80102913:	8b 45 08             	mov    0x8(%ebp),%eax
80102916:	8b 00                	mov    (%eax),%eax
80102918:	83 e0 01             	and    $0x1,%eax
8010291b:	85 c0                	test   %eax,%eax
8010291d:	75 0d                	jne    8010292c <iderw+0x1f>
    panic("iderw: buf not busy");
8010291f:	83 ec 0c             	sub    $0xc,%esp
80102922:	68 3d 88 10 80       	push   $0x8010883d
80102927:	e8 3a dc ff ff       	call   80100566 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010292c:	8b 45 08             	mov    0x8(%ebp),%eax
8010292f:	8b 00                	mov    (%eax),%eax
80102931:	83 e0 06             	and    $0x6,%eax
80102934:	83 f8 02             	cmp    $0x2,%eax
80102937:	75 0d                	jne    80102946 <iderw+0x39>
    panic("iderw: nothing to do");
80102939:	83 ec 0c             	sub    $0xc,%esp
8010293c:	68 51 88 10 80       	push   $0x80108851
80102941:	e8 20 dc ff ff       	call   80100566 <panic>
  if(b->dev != 0 && !havedisk1)
80102946:	8b 45 08             	mov    0x8(%ebp),%eax
80102949:	8b 40 04             	mov    0x4(%eax),%eax
8010294c:	85 c0                	test   %eax,%eax
8010294e:	74 16                	je     80102966 <iderw+0x59>
80102950:	a1 38 b6 10 80       	mov    0x8010b638,%eax
80102955:	85 c0                	test   %eax,%eax
80102957:	75 0d                	jne    80102966 <iderw+0x59>
    panic("iderw: ide disk 1 not present");
80102959:	83 ec 0c             	sub    $0xc,%esp
8010295c:	68 66 88 10 80       	push   $0x80108866
80102961:	e8 00 dc ff ff       	call   80100566 <panic>

  acquire(&idelock);  //DOC:acquire-lock
80102966:	83 ec 0c             	sub    $0xc,%esp
80102969:	68 00 b6 10 80       	push   $0x8010b600
8010296e:	e8 c2 27 00 00       	call   80105135 <acquire>
80102973:	83 c4 10             	add    $0x10,%esp

  // Append b to idequeue.
  b->qnext = 0;
80102976:	8b 45 08             	mov    0x8(%ebp),%eax
80102979:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102980:	c7 45 f4 34 b6 10 80 	movl   $0x8010b634,-0xc(%ebp)
80102987:	eb 0b                	jmp    80102994 <iderw+0x87>
80102989:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010298c:	8b 00                	mov    (%eax),%eax
8010298e:	83 c0 14             	add    $0x14,%eax
80102991:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102994:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102997:	8b 00                	mov    (%eax),%eax
80102999:	85 c0                	test   %eax,%eax
8010299b:	75 ec                	jne    80102989 <iderw+0x7c>
    ;
  *pp = b;
8010299d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029a0:	8b 55 08             	mov    0x8(%ebp),%edx
801029a3:	89 10                	mov    %edx,(%eax)
  
  // Start disk if necessary.
  if(idequeue == b)
801029a5:	a1 34 b6 10 80       	mov    0x8010b634,%eax
801029aa:	3b 45 08             	cmp    0x8(%ebp),%eax
801029ad:	75 23                	jne    801029d2 <iderw+0xc5>
    idestart(b);
801029af:	83 ec 0c             	sub    $0xc,%esp
801029b2:	ff 75 08             	pushl  0x8(%ebp)
801029b5:	e8 20 fd ff ff       	call   801026da <idestart>
801029ba:	83 c4 10             	add    $0x10,%esp
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801029bd:	eb 13                	jmp    801029d2 <iderw+0xc5>
    sleep(b, &idelock);
801029bf:	83 ec 08             	sub    $0x8,%esp
801029c2:	68 00 b6 10 80       	push   $0x8010b600
801029c7:	ff 75 08             	pushl  0x8(%ebp)
801029ca:	e8 7b 24 00 00       	call   80104e4a <sleep>
801029cf:	83 c4 10             	add    $0x10,%esp
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801029d2:	8b 45 08             	mov    0x8(%ebp),%eax
801029d5:	8b 00                	mov    (%eax),%eax
801029d7:	83 e0 06             	and    $0x6,%eax
801029da:	83 f8 02             	cmp    $0x2,%eax
801029dd:	75 e0                	jne    801029bf <iderw+0xb2>
  }

  release(&idelock);
801029df:	83 ec 0c             	sub    $0xc,%esp
801029e2:	68 00 b6 10 80       	push   $0x8010b600
801029e7:	e8 b0 27 00 00       	call   8010519c <release>
801029ec:	83 c4 10             	add    $0x10,%esp
}
801029ef:	90                   	nop
801029f0:	c9                   	leave  
801029f1:	c3                   	ret    

801029f2 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
801029f2:	55                   	push   %ebp
801029f3:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
801029f5:	a1 14 22 11 80       	mov    0x80112214,%eax
801029fa:	8b 55 08             	mov    0x8(%ebp),%edx
801029fd:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
801029ff:	a1 14 22 11 80       	mov    0x80112214,%eax
80102a04:	8b 40 10             	mov    0x10(%eax),%eax
}
80102a07:	5d                   	pop    %ebp
80102a08:	c3                   	ret    

80102a09 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
80102a09:	55                   	push   %ebp
80102a0a:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102a0c:	a1 14 22 11 80       	mov    0x80112214,%eax
80102a11:	8b 55 08             	mov    0x8(%ebp),%edx
80102a14:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102a16:	a1 14 22 11 80       	mov    0x80112214,%eax
80102a1b:	8b 55 0c             	mov    0xc(%ebp),%edx
80102a1e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102a21:	90                   	nop
80102a22:	5d                   	pop    %ebp
80102a23:	c3                   	ret    

80102a24 <ioapicinit>:

void
ioapicinit(void)
{
80102a24:	55                   	push   %ebp
80102a25:	89 e5                	mov    %esp,%ebp
80102a27:	83 ec 18             	sub    $0x18,%esp
  int i, id, maxintr;

  if(!ismp)
80102a2a:	a1 44 23 11 80       	mov    0x80112344,%eax
80102a2f:	85 c0                	test   %eax,%eax
80102a31:	0f 84 a0 00 00 00    	je     80102ad7 <ioapicinit+0xb3>
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102a37:	c7 05 14 22 11 80 00 	movl   $0xfec00000,0x80112214
80102a3e:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102a41:	6a 01                	push   $0x1
80102a43:	e8 aa ff ff ff       	call   801029f2 <ioapicread>
80102a48:	83 c4 04             	add    $0x4,%esp
80102a4b:	c1 e8 10             	shr    $0x10,%eax
80102a4e:	25 ff 00 00 00       	and    $0xff,%eax
80102a53:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
80102a56:	6a 00                	push   $0x0
80102a58:	e8 95 ff ff ff       	call   801029f2 <ioapicread>
80102a5d:	83 c4 04             	add    $0x4,%esp
80102a60:	c1 e8 18             	shr    $0x18,%eax
80102a63:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
80102a66:	0f b6 05 40 23 11 80 	movzbl 0x80112340,%eax
80102a6d:	0f b6 c0             	movzbl %al,%eax
80102a70:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80102a73:	74 10                	je     80102a85 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102a75:	83 ec 0c             	sub    $0xc,%esp
80102a78:	68 84 88 10 80       	push   $0x80108884
80102a7d:	e8 44 d9 ff ff       	call   801003c6 <cprintf>
80102a82:	83 c4 10             	add    $0x10,%esp

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102a85:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102a8c:	eb 3f                	jmp    80102acd <ioapicinit+0xa9>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102a8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a91:	83 c0 20             	add    $0x20,%eax
80102a94:	0d 00 00 01 00       	or     $0x10000,%eax
80102a99:	89 c2                	mov    %eax,%edx
80102a9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a9e:	83 c0 08             	add    $0x8,%eax
80102aa1:	01 c0                	add    %eax,%eax
80102aa3:	83 ec 08             	sub    $0x8,%esp
80102aa6:	52                   	push   %edx
80102aa7:	50                   	push   %eax
80102aa8:	e8 5c ff ff ff       	call   80102a09 <ioapicwrite>
80102aad:	83 c4 10             	add    $0x10,%esp
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102ab0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ab3:	83 c0 08             	add    $0x8,%eax
80102ab6:	01 c0                	add    %eax,%eax
80102ab8:	83 c0 01             	add    $0x1,%eax
80102abb:	83 ec 08             	sub    $0x8,%esp
80102abe:	6a 00                	push   $0x0
80102ac0:	50                   	push   %eax
80102ac1:	e8 43 ff ff ff       	call   80102a09 <ioapicwrite>
80102ac6:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i <= maxintr; i++){
80102ac9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102acd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ad0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102ad3:	7e b9                	jle    80102a8e <ioapicinit+0x6a>
80102ad5:	eb 01                	jmp    80102ad8 <ioapicinit+0xb4>
    return;
80102ad7:	90                   	nop
  }
}
80102ad8:	c9                   	leave  
80102ad9:	c3                   	ret    

80102ada <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102ada:	55                   	push   %ebp
80102adb:	89 e5                	mov    %esp,%ebp
  if(!ismp)
80102add:	a1 44 23 11 80       	mov    0x80112344,%eax
80102ae2:	85 c0                	test   %eax,%eax
80102ae4:	74 39                	je     80102b1f <ioapicenable+0x45>
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102ae6:	8b 45 08             	mov    0x8(%ebp),%eax
80102ae9:	83 c0 20             	add    $0x20,%eax
80102aec:	89 c2                	mov    %eax,%edx
80102aee:	8b 45 08             	mov    0x8(%ebp),%eax
80102af1:	83 c0 08             	add    $0x8,%eax
80102af4:	01 c0                	add    %eax,%eax
80102af6:	52                   	push   %edx
80102af7:	50                   	push   %eax
80102af8:	e8 0c ff ff ff       	call   80102a09 <ioapicwrite>
80102afd:	83 c4 08             	add    $0x8,%esp
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102b00:	8b 45 0c             	mov    0xc(%ebp),%eax
80102b03:	c1 e0 18             	shl    $0x18,%eax
80102b06:	89 c2                	mov    %eax,%edx
80102b08:	8b 45 08             	mov    0x8(%ebp),%eax
80102b0b:	83 c0 08             	add    $0x8,%eax
80102b0e:	01 c0                	add    %eax,%eax
80102b10:	83 c0 01             	add    $0x1,%eax
80102b13:	52                   	push   %edx
80102b14:	50                   	push   %eax
80102b15:	e8 ef fe ff ff       	call   80102a09 <ioapicwrite>
80102b1a:	83 c4 08             	add    $0x8,%esp
80102b1d:	eb 01                	jmp    80102b20 <ioapicenable+0x46>
    return;
80102b1f:	90                   	nop
}
80102b20:	c9                   	leave  
80102b21:	c3                   	ret    

80102b22 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80102b22:	55                   	push   %ebp
80102b23:	89 e5                	mov    %esp,%ebp
80102b25:	8b 45 08             	mov    0x8(%ebp),%eax
80102b28:	05 00 00 00 80       	add    $0x80000000,%eax
80102b2d:	5d                   	pop    %ebp
80102b2e:	c3                   	ret    

80102b2f <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102b2f:	55                   	push   %ebp
80102b30:	89 e5                	mov    %esp,%ebp
80102b32:	83 ec 08             	sub    $0x8,%esp
  initlock(&kmem.lock, "kmem");
80102b35:	83 ec 08             	sub    $0x8,%esp
80102b38:	68 b6 88 10 80       	push   $0x801088b6
80102b3d:	68 20 22 11 80       	push   $0x80112220
80102b42:	e8 cc 25 00 00       	call   80105113 <initlock>
80102b47:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102b4a:	c7 05 54 22 11 80 00 	movl   $0x0,0x80112254
80102b51:	00 00 00 
  freerange(vstart, vend);
80102b54:	83 ec 08             	sub    $0x8,%esp
80102b57:	ff 75 0c             	pushl  0xc(%ebp)
80102b5a:	ff 75 08             	pushl  0x8(%ebp)
80102b5d:	e8 2a 00 00 00       	call   80102b8c <freerange>
80102b62:	83 c4 10             	add    $0x10,%esp
}
80102b65:	90                   	nop
80102b66:	c9                   	leave  
80102b67:	c3                   	ret    

80102b68 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102b68:	55                   	push   %ebp
80102b69:	89 e5                	mov    %esp,%ebp
80102b6b:	83 ec 08             	sub    $0x8,%esp
  freerange(vstart, vend);
80102b6e:	83 ec 08             	sub    $0x8,%esp
80102b71:	ff 75 0c             	pushl  0xc(%ebp)
80102b74:	ff 75 08             	pushl  0x8(%ebp)
80102b77:	e8 10 00 00 00       	call   80102b8c <freerange>
80102b7c:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 1;
80102b7f:	c7 05 54 22 11 80 01 	movl   $0x1,0x80112254
80102b86:	00 00 00 
}
80102b89:	90                   	nop
80102b8a:	c9                   	leave  
80102b8b:	c3                   	ret    

80102b8c <freerange>:

void
freerange(void *vstart, void *vend)
{
80102b8c:	55                   	push   %ebp
80102b8d:	89 e5                	mov    %esp,%ebp
80102b8f:	83 ec 18             	sub    $0x18,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102b92:	8b 45 08             	mov    0x8(%ebp),%eax
80102b95:	05 ff 0f 00 00       	add    $0xfff,%eax
80102b9a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102b9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102ba2:	eb 15                	jmp    80102bb9 <freerange+0x2d>
    kfree(p);
80102ba4:	83 ec 0c             	sub    $0xc,%esp
80102ba7:	ff 75 f4             	pushl  -0xc(%ebp)
80102baa:	e8 1a 00 00 00       	call   80102bc9 <kfree>
80102baf:	83 c4 10             	add    $0x10,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102bb2:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102bb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102bbc:	05 00 10 00 00       	add    $0x1000,%eax
80102bc1:	3b 45 0c             	cmp    0xc(%ebp),%eax
80102bc4:	76 de                	jbe    80102ba4 <freerange+0x18>
}
80102bc6:	90                   	nop
80102bc7:	c9                   	leave  
80102bc8:	c3                   	ret    

80102bc9 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102bc9:	55                   	push   %ebp
80102bca:	89 e5                	mov    %esp,%ebp
80102bcc:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
80102bcf:	8b 45 08             	mov    0x8(%ebp),%eax
80102bd2:	25 ff 0f 00 00       	and    $0xfff,%eax
80102bd7:	85 c0                	test   %eax,%eax
80102bd9:	75 1b                	jne    80102bf6 <kfree+0x2d>
80102bdb:	81 7d 08 3c 52 11 80 	cmpl   $0x8011523c,0x8(%ebp)
80102be2:	72 12                	jb     80102bf6 <kfree+0x2d>
80102be4:	ff 75 08             	pushl  0x8(%ebp)
80102be7:	e8 36 ff ff ff       	call   80102b22 <v2p>
80102bec:	83 c4 04             	add    $0x4,%esp
80102bef:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102bf4:	76 0d                	jbe    80102c03 <kfree+0x3a>
    panic("kfree");
80102bf6:	83 ec 0c             	sub    $0xc,%esp
80102bf9:	68 bb 88 10 80       	push   $0x801088bb
80102bfe:	e8 63 d9 ff ff       	call   80100566 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102c03:	83 ec 04             	sub    $0x4,%esp
80102c06:	68 00 10 00 00       	push   $0x1000
80102c0b:	6a 01                	push   $0x1
80102c0d:	ff 75 08             	pushl  0x8(%ebp)
80102c10:	e8 83 27 00 00       	call   80105398 <memset>
80102c15:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
80102c18:	a1 54 22 11 80       	mov    0x80112254,%eax
80102c1d:	85 c0                	test   %eax,%eax
80102c1f:	74 10                	je     80102c31 <kfree+0x68>
    acquire(&kmem.lock);
80102c21:	83 ec 0c             	sub    $0xc,%esp
80102c24:	68 20 22 11 80       	push   $0x80112220
80102c29:	e8 07 25 00 00       	call   80105135 <acquire>
80102c2e:	83 c4 10             	add    $0x10,%esp
  r = (struct run*)v;
80102c31:	8b 45 08             	mov    0x8(%ebp),%eax
80102c34:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102c37:	8b 15 58 22 11 80    	mov    0x80112258,%edx
80102c3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c40:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102c42:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c45:	a3 58 22 11 80       	mov    %eax,0x80112258
  if(kmem.use_lock)
80102c4a:	a1 54 22 11 80       	mov    0x80112254,%eax
80102c4f:	85 c0                	test   %eax,%eax
80102c51:	74 10                	je     80102c63 <kfree+0x9a>
    release(&kmem.lock);
80102c53:	83 ec 0c             	sub    $0xc,%esp
80102c56:	68 20 22 11 80       	push   $0x80112220
80102c5b:	e8 3c 25 00 00       	call   8010519c <release>
80102c60:	83 c4 10             	add    $0x10,%esp
}
80102c63:	90                   	nop
80102c64:	c9                   	leave  
80102c65:	c3                   	ret    

80102c66 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102c66:	55                   	push   %ebp
80102c67:	89 e5                	mov    %esp,%ebp
80102c69:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if(kmem.use_lock)
80102c6c:	a1 54 22 11 80       	mov    0x80112254,%eax
80102c71:	85 c0                	test   %eax,%eax
80102c73:	74 10                	je     80102c85 <kalloc+0x1f>
    acquire(&kmem.lock);
80102c75:	83 ec 0c             	sub    $0xc,%esp
80102c78:	68 20 22 11 80       	push   $0x80112220
80102c7d:	e8 b3 24 00 00       	call   80105135 <acquire>
80102c82:	83 c4 10             	add    $0x10,%esp
  r = kmem.freelist;
80102c85:	a1 58 22 11 80       	mov    0x80112258,%eax
80102c8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102c8d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102c91:	74 0a                	je     80102c9d <kalloc+0x37>
    kmem.freelist = r->next;
80102c93:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c96:	8b 00                	mov    (%eax),%eax
80102c98:	a3 58 22 11 80       	mov    %eax,0x80112258
  if(kmem.use_lock)
80102c9d:	a1 54 22 11 80       	mov    0x80112254,%eax
80102ca2:	85 c0                	test   %eax,%eax
80102ca4:	74 10                	je     80102cb6 <kalloc+0x50>
    release(&kmem.lock);
80102ca6:	83 ec 0c             	sub    $0xc,%esp
80102ca9:	68 20 22 11 80       	push   $0x80112220
80102cae:	e8 e9 24 00 00       	call   8010519c <release>
80102cb3:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
80102cb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102cb9:	c9                   	leave  
80102cba:	c3                   	ret    

80102cbb <inb>:
{
80102cbb:	55                   	push   %ebp
80102cbc:	89 e5                	mov    %esp,%ebp
80102cbe:	83 ec 14             	sub    $0x14,%esp
80102cc1:	8b 45 08             	mov    0x8(%ebp),%eax
80102cc4:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cc8:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102ccc:	89 c2                	mov    %eax,%edx
80102cce:	ec                   	in     (%dx),%al
80102ccf:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102cd2:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102cd6:	c9                   	leave  
80102cd7:	c3                   	ret    

80102cd8 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102cd8:	55                   	push   %ebp
80102cd9:	89 e5                	mov    %esp,%ebp
80102cdb:	83 ec 10             	sub    $0x10,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102cde:	6a 64                	push   $0x64
80102ce0:	e8 d6 ff ff ff       	call   80102cbb <inb>
80102ce5:	83 c4 04             	add    $0x4,%esp
80102ce8:	0f b6 c0             	movzbl %al,%eax
80102ceb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102cee:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102cf1:	83 e0 01             	and    $0x1,%eax
80102cf4:	85 c0                	test   %eax,%eax
80102cf6:	75 0a                	jne    80102d02 <kbdgetc+0x2a>
    return -1;
80102cf8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102cfd:	e9 23 01 00 00       	jmp    80102e25 <kbdgetc+0x14d>
  data = inb(KBDATAP);
80102d02:	6a 60                	push   $0x60
80102d04:	e8 b2 ff ff ff       	call   80102cbb <inb>
80102d09:	83 c4 04             	add    $0x4,%esp
80102d0c:	0f b6 c0             	movzbl %al,%eax
80102d0f:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102d12:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102d19:	75 17                	jne    80102d32 <kbdgetc+0x5a>
    shift |= E0ESC;
80102d1b:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102d20:	83 c8 40             	or     $0x40,%eax
80102d23:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
    return 0;
80102d28:	b8 00 00 00 00       	mov    $0x0,%eax
80102d2d:	e9 f3 00 00 00       	jmp    80102e25 <kbdgetc+0x14d>
  } else if(data & 0x80){
80102d32:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d35:	25 80 00 00 00       	and    $0x80,%eax
80102d3a:	85 c0                	test   %eax,%eax
80102d3c:	74 45                	je     80102d83 <kbdgetc+0xab>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102d3e:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102d43:	83 e0 40             	and    $0x40,%eax
80102d46:	85 c0                	test   %eax,%eax
80102d48:	75 08                	jne    80102d52 <kbdgetc+0x7a>
80102d4a:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d4d:	83 e0 7f             	and    $0x7f,%eax
80102d50:	eb 03                	jmp    80102d55 <kbdgetc+0x7d>
80102d52:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d55:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102d58:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d5b:	05 20 90 10 80       	add    $0x80109020,%eax
80102d60:	0f b6 00             	movzbl (%eax),%eax
80102d63:	83 c8 40             	or     $0x40,%eax
80102d66:	0f b6 c0             	movzbl %al,%eax
80102d69:	f7 d0                	not    %eax
80102d6b:	89 c2                	mov    %eax,%edx
80102d6d:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102d72:	21 d0                	and    %edx,%eax
80102d74:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
    return 0;
80102d79:	b8 00 00 00 00       	mov    $0x0,%eax
80102d7e:	e9 a2 00 00 00       	jmp    80102e25 <kbdgetc+0x14d>
  } else if(shift & E0ESC){
80102d83:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102d88:	83 e0 40             	and    $0x40,%eax
80102d8b:	85 c0                	test   %eax,%eax
80102d8d:	74 14                	je     80102da3 <kbdgetc+0xcb>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102d8f:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102d96:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102d9b:	83 e0 bf             	and    $0xffffffbf,%eax
80102d9e:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
  }

  shift |= shiftcode[data];
80102da3:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102da6:	05 20 90 10 80       	add    $0x80109020,%eax
80102dab:	0f b6 00             	movzbl (%eax),%eax
80102dae:	0f b6 d0             	movzbl %al,%edx
80102db1:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102db6:	09 d0                	or     %edx,%eax
80102db8:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
  shift ^= togglecode[data];
80102dbd:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102dc0:	05 20 91 10 80       	add    $0x80109120,%eax
80102dc5:	0f b6 00             	movzbl (%eax),%eax
80102dc8:	0f b6 d0             	movzbl %al,%edx
80102dcb:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102dd0:	31 d0                	xor    %edx,%eax
80102dd2:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
  c = charcode[shift & (CTL | SHIFT)][data];
80102dd7:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102ddc:	83 e0 03             	and    $0x3,%eax
80102ddf:	8b 14 85 20 95 10 80 	mov    -0x7fef6ae0(,%eax,4),%edx
80102de6:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102de9:	01 d0                	add    %edx,%eax
80102deb:	0f b6 00             	movzbl (%eax),%eax
80102dee:	0f b6 c0             	movzbl %al,%eax
80102df1:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102df4:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102df9:	83 e0 08             	and    $0x8,%eax
80102dfc:	85 c0                	test   %eax,%eax
80102dfe:	74 22                	je     80102e22 <kbdgetc+0x14a>
    if('a' <= c && c <= 'z')
80102e00:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102e04:	76 0c                	jbe    80102e12 <kbdgetc+0x13a>
80102e06:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102e0a:	77 06                	ja     80102e12 <kbdgetc+0x13a>
      c += 'A' - 'a';
80102e0c:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102e10:	eb 10                	jmp    80102e22 <kbdgetc+0x14a>
    else if('A' <= c && c <= 'Z')
80102e12:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102e16:	76 0a                	jbe    80102e22 <kbdgetc+0x14a>
80102e18:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102e1c:	77 04                	ja     80102e22 <kbdgetc+0x14a>
      c += 'a' - 'A';
80102e1e:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102e22:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102e25:	c9                   	leave  
80102e26:	c3                   	ret    

80102e27 <kbdintr>:

void
kbdintr(void)
{
80102e27:	55                   	push   %ebp
80102e28:	89 e5                	mov    %esp,%ebp
80102e2a:	83 ec 08             	sub    $0x8,%esp
  consoleintr(kbdgetc);
80102e2d:	83 ec 0c             	sub    $0xc,%esp
80102e30:	68 d8 2c 10 80       	push   $0x80102cd8
80102e35:	e8 bf d9 ff ff       	call   801007f9 <consoleintr>
80102e3a:	83 c4 10             	add    $0x10,%esp
}
80102e3d:	90                   	nop
80102e3e:	c9                   	leave  
80102e3f:	c3                   	ret    

80102e40 <inb>:
{
80102e40:	55                   	push   %ebp
80102e41:	89 e5                	mov    %esp,%ebp
80102e43:	83 ec 14             	sub    $0x14,%esp
80102e46:	8b 45 08             	mov    0x8(%ebp),%eax
80102e49:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e4d:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102e51:	89 c2                	mov    %eax,%edx
80102e53:	ec                   	in     (%dx),%al
80102e54:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102e57:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102e5b:	c9                   	leave  
80102e5c:	c3                   	ret    

80102e5d <outb>:
{
80102e5d:	55                   	push   %ebp
80102e5e:	89 e5                	mov    %esp,%ebp
80102e60:	83 ec 08             	sub    $0x8,%esp
80102e63:	8b 55 08             	mov    0x8(%ebp),%edx
80102e66:	8b 45 0c             	mov    0xc(%ebp),%eax
80102e69:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102e6d:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e70:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102e74:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102e78:	ee                   	out    %al,(%dx)
}
80102e79:	90                   	nop
80102e7a:	c9                   	leave  
80102e7b:	c3                   	ret    

80102e7c <readeflags>:
{
80102e7c:	55                   	push   %ebp
80102e7d:	89 e5                	mov    %esp,%ebp
80102e7f:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102e82:	9c                   	pushf  
80102e83:	58                   	pop    %eax
80102e84:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80102e87:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80102e8a:	c9                   	leave  
80102e8b:	c3                   	ret    

80102e8c <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
80102e8c:	55                   	push   %ebp
80102e8d:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102e8f:	a1 5c 22 11 80       	mov    0x8011225c,%eax
80102e94:	8b 55 08             	mov    0x8(%ebp),%edx
80102e97:	c1 e2 02             	shl    $0x2,%edx
80102e9a:	01 c2                	add    %eax,%edx
80102e9c:	8b 45 0c             	mov    0xc(%ebp),%eax
80102e9f:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102ea1:	a1 5c 22 11 80       	mov    0x8011225c,%eax
80102ea6:	83 c0 20             	add    $0x20,%eax
80102ea9:	8b 00                	mov    (%eax),%eax
}
80102eab:	90                   	nop
80102eac:	5d                   	pop    %ebp
80102ead:	c3                   	ret    

80102eae <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
80102eae:	55                   	push   %ebp
80102eaf:	89 e5                	mov    %esp,%ebp
  if(!lapic) 
80102eb1:	a1 5c 22 11 80       	mov    0x8011225c,%eax
80102eb6:	85 c0                	test   %eax,%eax
80102eb8:	0f 84 0b 01 00 00    	je     80102fc9 <lapicinit+0x11b>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102ebe:	68 3f 01 00 00       	push   $0x13f
80102ec3:	6a 3c                	push   $0x3c
80102ec5:	e8 c2 ff ff ff       	call   80102e8c <lapicw>
80102eca:	83 c4 08             	add    $0x8,%esp

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80102ecd:	6a 0b                	push   $0xb
80102ecf:	68 f8 00 00 00       	push   $0xf8
80102ed4:	e8 b3 ff ff ff       	call   80102e8c <lapicw>
80102ed9:	83 c4 08             	add    $0x8,%esp
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102edc:	68 20 00 02 00       	push   $0x20020
80102ee1:	68 c8 00 00 00       	push   $0xc8
80102ee6:	e8 a1 ff ff ff       	call   80102e8c <lapicw>
80102eeb:	83 c4 08             	add    $0x8,%esp
  lapicw(TICR, 10000000); 
80102eee:	68 80 96 98 00       	push   $0x989680
80102ef3:	68 e0 00 00 00       	push   $0xe0
80102ef8:	e8 8f ff ff ff       	call   80102e8c <lapicw>
80102efd:	83 c4 08             	add    $0x8,%esp

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102f00:	68 00 00 01 00       	push   $0x10000
80102f05:	68 d4 00 00 00       	push   $0xd4
80102f0a:	e8 7d ff ff ff       	call   80102e8c <lapicw>
80102f0f:	83 c4 08             	add    $0x8,%esp
  lapicw(LINT1, MASKED);
80102f12:	68 00 00 01 00       	push   $0x10000
80102f17:	68 d8 00 00 00       	push   $0xd8
80102f1c:	e8 6b ff ff ff       	call   80102e8c <lapicw>
80102f21:	83 c4 08             	add    $0x8,%esp

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102f24:	a1 5c 22 11 80       	mov    0x8011225c,%eax
80102f29:	83 c0 30             	add    $0x30,%eax
80102f2c:	8b 00                	mov    (%eax),%eax
80102f2e:	c1 e8 10             	shr    $0x10,%eax
80102f31:	0f b6 c0             	movzbl %al,%eax
80102f34:	83 f8 03             	cmp    $0x3,%eax
80102f37:	76 12                	jbe    80102f4b <lapicinit+0x9d>
    lapicw(PCINT, MASKED);
80102f39:	68 00 00 01 00       	push   $0x10000
80102f3e:	68 d0 00 00 00       	push   $0xd0
80102f43:	e8 44 ff ff ff       	call   80102e8c <lapicw>
80102f48:	83 c4 08             	add    $0x8,%esp

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102f4b:	6a 33                	push   $0x33
80102f4d:	68 dc 00 00 00       	push   $0xdc
80102f52:	e8 35 ff ff ff       	call   80102e8c <lapicw>
80102f57:	83 c4 08             	add    $0x8,%esp

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80102f5a:	6a 00                	push   $0x0
80102f5c:	68 a0 00 00 00       	push   $0xa0
80102f61:	e8 26 ff ff ff       	call   80102e8c <lapicw>
80102f66:	83 c4 08             	add    $0x8,%esp
  lapicw(ESR, 0);
80102f69:	6a 00                	push   $0x0
80102f6b:	68 a0 00 00 00       	push   $0xa0
80102f70:	e8 17 ff ff ff       	call   80102e8c <lapicw>
80102f75:	83 c4 08             	add    $0x8,%esp

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80102f78:	6a 00                	push   $0x0
80102f7a:	6a 2c                	push   $0x2c
80102f7c:	e8 0b ff ff ff       	call   80102e8c <lapicw>
80102f81:	83 c4 08             	add    $0x8,%esp

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80102f84:	6a 00                	push   $0x0
80102f86:	68 c4 00 00 00       	push   $0xc4
80102f8b:	e8 fc fe ff ff       	call   80102e8c <lapicw>
80102f90:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80102f93:	68 00 85 08 00       	push   $0x88500
80102f98:	68 c0 00 00 00       	push   $0xc0
80102f9d:	e8 ea fe ff ff       	call   80102e8c <lapicw>
80102fa2:	83 c4 08             	add    $0x8,%esp
  while(lapic[ICRLO] & DELIVS)
80102fa5:	90                   	nop
80102fa6:	a1 5c 22 11 80       	mov    0x8011225c,%eax
80102fab:	05 00 03 00 00       	add    $0x300,%eax
80102fb0:	8b 00                	mov    (%eax),%eax
80102fb2:	25 00 10 00 00       	and    $0x1000,%eax
80102fb7:	85 c0                	test   %eax,%eax
80102fb9:	75 eb                	jne    80102fa6 <lapicinit+0xf8>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80102fbb:	6a 00                	push   $0x0
80102fbd:	6a 20                	push   $0x20
80102fbf:	e8 c8 fe ff ff       	call   80102e8c <lapicw>
80102fc4:	83 c4 08             	add    $0x8,%esp
80102fc7:	eb 01                	jmp    80102fca <lapicinit+0x11c>
    return;
80102fc9:	90                   	nop
}
80102fca:	c9                   	leave  
80102fcb:	c3                   	ret    

80102fcc <cpunum>:

int
cpunum(void)
{
80102fcc:	55                   	push   %ebp
80102fcd:	89 e5                	mov    %esp,%ebp
80102fcf:	83 ec 08             	sub    $0x8,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
80102fd2:	e8 a5 fe ff ff       	call   80102e7c <readeflags>
80102fd7:	25 00 02 00 00       	and    $0x200,%eax
80102fdc:	85 c0                	test   %eax,%eax
80102fde:	74 26                	je     80103006 <cpunum+0x3a>
    static int n;
    if(n++ == 0)
80102fe0:	a1 40 b6 10 80       	mov    0x8010b640,%eax
80102fe5:	8d 50 01             	lea    0x1(%eax),%edx
80102fe8:	89 15 40 b6 10 80    	mov    %edx,0x8010b640
80102fee:	85 c0                	test   %eax,%eax
80102ff0:	75 14                	jne    80103006 <cpunum+0x3a>
      cprintf("cpu called from %x with interrupts enabled\n",
80102ff2:	8b 45 04             	mov    0x4(%ebp),%eax
80102ff5:	83 ec 08             	sub    $0x8,%esp
80102ff8:	50                   	push   %eax
80102ff9:	68 c4 88 10 80       	push   $0x801088c4
80102ffe:	e8 c3 d3 ff ff       	call   801003c6 <cprintf>
80103003:	83 c4 10             	add    $0x10,%esp
        __builtin_return_address(0));
  }

  if(lapic)
80103006:	a1 5c 22 11 80       	mov    0x8011225c,%eax
8010300b:	85 c0                	test   %eax,%eax
8010300d:	74 0f                	je     8010301e <cpunum+0x52>
    return lapic[ID]>>24;
8010300f:	a1 5c 22 11 80       	mov    0x8011225c,%eax
80103014:	83 c0 20             	add    $0x20,%eax
80103017:	8b 00                	mov    (%eax),%eax
80103019:	c1 e8 18             	shr    $0x18,%eax
8010301c:	eb 05                	jmp    80103023 <cpunum+0x57>
  return 0;
8010301e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103023:	c9                   	leave  
80103024:	c3                   	ret    

80103025 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80103025:	55                   	push   %ebp
80103026:	89 e5                	mov    %esp,%ebp
  if(lapic)
80103028:	a1 5c 22 11 80       	mov    0x8011225c,%eax
8010302d:	85 c0                	test   %eax,%eax
8010302f:	74 0c                	je     8010303d <lapiceoi+0x18>
    lapicw(EOI, 0);
80103031:	6a 00                	push   $0x0
80103033:	6a 2c                	push   $0x2c
80103035:	e8 52 fe ff ff       	call   80102e8c <lapicw>
8010303a:	83 c4 08             	add    $0x8,%esp
}
8010303d:	90                   	nop
8010303e:	c9                   	leave  
8010303f:	c3                   	ret    

80103040 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80103040:	55                   	push   %ebp
80103041:	89 e5                	mov    %esp,%ebp
}
80103043:	90                   	nop
80103044:	5d                   	pop    %ebp
80103045:	c3                   	ret    

80103046 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80103046:	55                   	push   %ebp
80103047:	89 e5                	mov    %esp,%ebp
80103049:	83 ec 14             	sub    $0x14,%esp
8010304c:	8b 45 08             	mov    0x8(%ebp),%eax
8010304f:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;
  
  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
80103052:	6a 0f                	push   $0xf
80103054:	6a 70                	push   $0x70
80103056:	e8 02 fe ff ff       	call   80102e5d <outb>
8010305b:	83 c4 08             	add    $0x8,%esp
  outb(CMOS_PORT+1, 0x0A);
8010305e:	6a 0a                	push   $0xa
80103060:	6a 71                	push   $0x71
80103062:	e8 f6 fd ff ff       	call   80102e5d <outb>
80103067:	83 c4 08             	add    $0x8,%esp
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
8010306a:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
80103071:	8b 45 f8             	mov    -0x8(%ebp),%eax
80103074:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
80103079:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010307c:	83 c0 02             	add    $0x2,%eax
8010307f:	8b 55 0c             	mov    0xc(%ebp),%edx
80103082:	c1 ea 04             	shr    $0x4,%edx
80103085:	66 89 10             	mov    %dx,(%eax)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80103088:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
8010308c:	c1 e0 18             	shl    $0x18,%eax
8010308f:	50                   	push   %eax
80103090:	68 c4 00 00 00       	push   $0xc4
80103095:	e8 f2 fd ff ff       	call   80102e8c <lapicw>
8010309a:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
8010309d:	68 00 c5 00 00       	push   $0xc500
801030a2:	68 c0 00 00 00       	push   $0xc0
801030a7:	e8 e0 fd ff ff       	call   80102e8c <lapicw>
801030ac:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
801030af:	68 c8 00 00 00       	push   $0xc8
801030b4:	e8 87 ff ff ff       	call   80103040 <microdelay>
801030b9:	83 c4 04             	add    $0x4,%esp
  lapicw(ICRLO, INIT | LEVEL);
801030bc:	68 00 85 00 00       	push   $0x8500
801030c1:	68 c0 00 00 00       	push   $0xc0
801030c6:	e8 c1 fd ff ff       	call   80102e8c <lapicw>
801030cb:	83 c4 08             	add    $0x8,%esp
  microdelay(100);    // should be 10ms, but too slow in Bochs!
801030ce:	6a 64                	push   $0x64
801030d0:	e8 6b ff ff ff       	call   80103040 <microdelay>
801030d5:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
801030d8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801030df:	eb 3d                	jmp    8010311e <lapicstartap+0xd8>
    lapicw(ICRHI, apicid<<24);
801030e1:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
801030e5:	c1 e0 18             	shl    $0x18,%eax
801030e8:	50                   	push   %eax
801030e9:	68 c4 00 00 00       	push   $0xc4
801030ee:	e8 99 fd ff ff       	call   80102e8c <lapicw>
801030f3:	83 c4 08             	add    $0x8,%esp
    lapicw(ICRLO, STARTUP | (addr>>12));
801030f6:	8b 45 0c             	mov    0xc(%ebp),%eax
801030f9:	c1 e8 0c             	shr    $0xc,%eax
801030fc:	80 cc 06             	or     $0x6,%ah
801030ff:	50                   	push   %eax
80103100:	68 c0 00 00 00       	push   $0xc0
80103105:	e8 82 fd ff ff       	call   80102e8c <lapicw>
8010310a:	83 c4 08             	add    $0x8,%esp
    microdelay(200);
8010310d:	68 c8 00 00 00       	push   $0xc8
80103112:	e8 29 ff ff ff       	call   80103040 <microdelay>
80103117:	83 c4 04             	add    $0x4,%esp
  for(i = 0; i < 2; i++){
8010311a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010311e:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
80103122:	7e bd                	jle    801030e1 <lapicstartap+0x9b>
  }
}
80103124:	90                   	nop
80103125:	c9                   	leave  
80103126:	c3                   	ret    

80103127 <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
80103127:	55                   	push   %ebp
80103128:	89 e5                	mov    %esp,%ebp
  outb(CMOS_PORT,  reg);
8010312a:	8b 45 08             	mov    0x8(%ebp),%eax
8010312d:	0f b6 c0             	movzbl %al,%eax
80103130:	50                   	push   %eax
80103131:	6a 70                	push   $0x70
80103133:	e8 25 fd ff ff       	call   80102e5d <outb>
80103138:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
8010313b:	68 c8 00 00 00       	push   $0xc8
80103140:	e8 fb fe ff ff       	call   80103040 <microdelay>
80103145:	83 c4 04             	add    $0x4,%esp

  return inb(CMOS_RETURN);
80103148:	6a 71                	push   $0x71
8010314a:	e8 f1 fc ff ff       	call   80102e40 <inb>
8010314f:	83 c4 04             	add    $0x4,%esp
80103152:	0f b6 c0             	movzbl %al,%eax
}
80103155:	c9                   	leave  
80103156:	c3                   	ret    

80103157 <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
80103157:	55                   	push   %ebp
80103158:	89 e5                	mov    %esp,%ebp
  r->second = cmos_read(SECS);
8010315a:	6a 00                	push   $0x0
8010315c:	e8 c6 ff ff ff       	call   80103127 <cmos_read>
80103161:	83 c4 04             	add    $0x4,%esp
80103164:	89 c2                	mov    %eax,%edx
80103166:	8b 45 08             	mov    0x8(%ebp),%eax
80103169:	89 10                	mov    %edx,(%eax)
  r->minute = cmos_read(MINS);
8010316b:	6a 02                	push   $0x2
8010316d:	e8 b5 ff ff ff       	call   80103127 <cmos_read>
80103172:	83 c4 04             	add    $0x4,%esp
80103175:	89 c2                	mov    %eax,%edx
80103177:	8b 45 08             	mov    0x8(%ebp),%eax
8010317a:	89 50 04             	mov    %edx,0x4(%eax)
  r->hour   = cmos_read(HOURS);
8010317d:	6a 04                	push   $0x4
8010317f:	e8 a3 ff ff ff       	call   80103127 <cmos_read>
80103184:	83 c4 04             	add    $0x4,%esp
80103187:	89 c2                	mov    %eax,%edx
80103189:	8b 45 08             	mov    0x8(%ebp),%eax
8010318c:	89 50 08             	mov    %edx,0x8(%eax)
  r->day    = cmos_read(DAY);
8010318f:	6a 07                	push   $0x7
80103191:	e8 91 ff ff ff       	call   80103127 <cmos_read>
80103196:	83 c4 04             	add    $0x4,%esp
80103199:	89 c2                	mov    %eax,%edx
8010319b:	8b 45 08             	mov    0x8(%ebp),%eax
8010319e:	89 50 0c             	mov    %edx,0xc(%eax)
  r->month  = cmos_read(MONTH);
801031a1:	6a 08                	push   $0x8
801031a3:	e8 7f ff ff ff       	call   80103127 <cmos_read>
801031a8:	83 c4 04             	add    $0x4,%esp
801031ab:	89 c2                	mov    %eax,%edx
801031ad:	8b 45 08             	mov    0x8(%ebp),%eax
801031b0:	89 50 10             	mov    %edx,0x10(%eax)
  r->year   = cmos_read(YEAR);
801031b3:	6a 09                	push   $0x9
801031b5:	e8 6d ff ff ff       	call   80103127 <cmos_read>
801031ba:	83 c4 04             	add    $0x4,%esp
801031bd:	89 c2                	mov    %eax,%edx
801031bf:	8b 45 08             	mov    0x8(%ebp),%eax
801031c2:	89 50 14             	mov    %edx,0x14(%eax)
}
801031c5:	90                   	nop
801031c6:	c9                   	leave  
801031c7:	c3                   	ret    

801031c8 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
801031c8:	55                   	push   %ebp
801031c9:	89 e5                	mov    %esp,%ebp
801031cb:	83 ec 48             	sub    $0x48,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
801031ce:	6a 0b                	push   $0xb
801031d0:	e8 52 ff ff ff       	call   80103127 <cmos_read>
801031d5:	83 c4 04             	add    $0x4,%esp
801031d8:	89 45 f4             	mov    %eax,-0xc(%ebp)

  bcd = (sb & (1 << 2)) == 0;
801031db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801031de:	83 e0 04             	and    $0x4,%eax
801031e1:	85 c0                	test   %eax,%eax
801031e3:	0f 94 c0             	sete   %al
801031e6:	0f b6 c0             	movzbl %al,%eax
801031e9:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
801031ec:	8d 45 d8             	lea    -0x28(%ebp),%eax
801031ef:	50                   	push   %eax
801031f0:	e8 62 ff ff ff       	call   80103157 <fill_rtcdate>
801031f5:	83 c4 04             	add    $0x4,%esp
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
801031f8:	6a 0a                	push   $0xa
801031fa:	e8 28 ff ff ff       	call   80103127 <cmos_read>
801031ff:	83 c4 04             	add    $0x4,%esp
80103202:	25 80 00 00 00       	and    $0x80,%eax
80103207:	85 c0                	test   %eax,%eax
80103209:	75 27                	jne    80103232 <cmostime+0x6a>
        continue;
    fill_rtcdate(&t2);
8010320b:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010320e:	50                   	push   %eax
8010320f:	e8 43 ff ff ff       	call   80103157 <fill_rtcdate>
80103214:	83 c4 04             	add    $0x4,%esp
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
80103217:	83 ec 04             	sub    $0x4,%esp
8010321a:	6a 18                	push   $0x18
8010321c:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010321f:	50                   	push   %eax
80103220:	8d 45 d8             	lea    -0x28(%ebp),%eax
80103223:	50                   	push   %eax
80103224:	e8 d6 21 00 00       	call   801053ff <memcmp>
80103229:	83 c4 10             	add    $0x10,%esp
8010322c:	85 c0                	test   %eax,%eax
8010322e:	74 05                	je     80103235 <cmostime+0x6d>
80103230:	eb ba                	jmp    801031ec <cmostime+0x24>
        continue;
80103232:	90                   	nop
    fill_rtcdate(&t1);
80103233:	eb b7                	jmp    801031ec <cmostime+0x24>
      break;
80103235:	90                   	nop
  }

  // convert
  if (bcd) {
80103236:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010323a:	0f 84 b4 00 00 00    	je     801032f4 <cmostime+0x12c>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80103240:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103243:	c1 e8 04             	shr    $0x4,%eax
80103246:	89 c2                	mov    %eax,%edx
80103248:	89 d0                	mov    %edx,%eax
8010324a:	c1 e0 02             	shl    $0x2,%eax
8010324d:	01 d0                	add    %edx,%eax
8010324f:	01 c0                	add    %eax,%eax
80103251:	89 c2                	mov    %eax,%edx
80103253:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103256:	83 e0 0f             	and    $0xf,%eax
80103259:	01 d0                	add    %edx,%eax
8010325b:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(minute);
8010325e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103261:	c1 e8 04             	shr    $0x4,%eax
80103264:	89 c2                	mov    %eax,%edx
80103266:	89 d0                	mov    %edx,%eax
80103268:	c1 e0 02             	shl    $0x2,%eax
8010326b:	01 d0                	add    %edx,%eax
8010326d:	01 c0                	add    %eax,%eax
8010326f:	89 c2                	mov    %eax,%edx
80103271:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103274:	83 e0 0f             	and    $0xf,%eax
80103277:	01 d0                	add    %edx,%eax
80103279:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(hour  );
8010327c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010327f:	c1 e8 04             	shr    $0x4,%eax
80103282:	89 c2                	mov    %eax,%edx
80103284:	89 d0                	mov    %edx,%eax
80103286:	c1 e0 02             	shl    $0x2,%eax
80103289:	01 d0                	add    %edx,%eax
8010328b:	01 c0                	add    %eax,%eax
8010328d:	89 c2                	mov    %eax,%edx
8010328f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103292:	83 e0 0f             	and    $0xf,%eax
80103295:	01 d0                	add    %edx,%eax
80103297:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(day   );
8010329a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010329d:	c1 e8 04             	shr    $0x4,%eax
801032a0:	89 c2                	mov    %eax,%edx
801032a2:	89 d0                	mov    %edx,%eax
801032a4:	c1 e0 02             	shl    $0x2,%eax
801032a7:	01 d0                	add    %edx,%eax
801032a9:	01 c0                	add    %eax,%eax
801032ab:	89 c2                	mov    %eax,%edx
801032ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801032b0:	83 e0 0f             	and    $0xf,%eax
801032b3:	01 d0                	add    %edx,%eax
801032b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    CONV(month );
801032b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
801032bb:	c1 e8 04             	shr    $0x4,%eax
801032be:	89 c2                	mov    %eax,%edx
801032c0:	89 d0                	mov    %edx,%eax
801032c2:	c1 e0 02             	shl    $0x2,%eax
801032c5:	01 d0                	add    %edx,%eax
801032c7:	01 c0                	add    %eax,%eax
801032c9:	89 c2                	mov    %eax,%edx
801032cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
801032ce:	83 e0 0f             	and    $0xf,%eax
801032d1:	01 d0                	add    %edx,%eax
801032d3:	89 45 e8             	mov    %eax,-0x18(%ebp)
    CONV(year  );
801032d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801032d9:	c1 e8 04             	shr    $0x4,%eax
801032dc:	89 c2                	mov    %eax,%edx
801032de:	89 d0                	mov    %edx,%eax
801032e0:	c1 e0 02             	shl    $0x2,%eax
801032e3:	01 d0                	add    %edx,%eax
801032e5:	01 c0                	add    %eax,%eax
801032e7:	89 c2                	mov    %eax,%edx
801032e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801032ec:	83 e0 0f             	and    $0xf,%eax
801032ef:	01 d0                	add    %edx,%eax
801032f1:	89 45 ec             	mov    %eax,-0x14(%ebp)
#undef     CONV
  }

  *r = t1;
801032f4:	8b 45 08             	mov    0x8(%ebp),%eax
801032f7:	8b 55 d8             	mov    -0x28(%ebp),%edx
801032fa:	89 10                	mov    %edx,(%eax)
801032fc:	8b 55 dc             	mov    -0x24(%ebp),%edx
801032ff:	89 50 04             	mov    %edx,0x4(%eax)
80103302:	8b 55 e0             	mov    -0x20(%ebp),%edx
80103305:	89 50 08             	mov    %edx,0x8(%eax)
80103308:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010330b:	89 50 0c             	mov    %edx,0xc(%eax)
8010330e:	8b 55 e8             	mov    -0x18(%ebp),%edx
80103311:	89 50 10             	mov    %edx,0x10(%eax)
80103314:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103317:	89 50 14             	mov    %edx,0x14(%eax)
  r->year += 2000;
8010331a:	8b 45 08             	mov    0x8(%ebp),%eax
8010331d:	8b 40 14             	mov    0x14(%eax),%eax
80103320:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
80103326:	8b 45 08             	mov    0x8(%ebp),%eax
80103329:	89 50 14             	mov    %edx,0x14(%eax)
}
8010332c:	90                   	nop
8010332d:	c9                   	leave  
8010332e:	c3                   	ret    

8010332f <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
8010332f:	55                   	push   %ebp
80103330:	89 e5                	mov    %esp,%ebp
80103332:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80103335:	83 ec 08             	sub    $0x8,%esp
80103338:	68 f0 88 10 80       	push   $0x801088f0
8010333d:	68 60 22 11 80       	push   $0x80112260
80103342:	e8 cc 1d 00 00       	call   80105113 <initlock>
80103347:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
8010334a:	83 ec 08             	sub    $0x8,%esp
8010334d:	8d 45 dc             	lea    -0x24(%ebp),%eax
80103350:	50                   	push   %eax
80103351:	ff 75 08             	pushl  0x8(%ebp)
80103354:	e8 2b e0 ff ff       	call   80101384 <readsb>
80103359:	83 c4 10             	add    $0x10,%esp
  log.start = sb.logstart;
8010335c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010335f:	a3 94 22 11 80       	mov    %eax,0x80112294
  log.size = sb.nlog;
80103364:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103367:	a3 98 22 11 80       	mov    %eax,0x80112298
  log.dev = dev;
8010336c:	8b 45 08             	mov    0x8(%ebp),%eax
8010336f:	a3 a4 22 11 80       	mov    %eax,0x801122a4
  recover_from_log();
80103374:	e8 b2 01 00 00       	call   8010352b <recover_from_log>
}
80103379:	90                   	nop
8010337a:	c9                   	leave  
8010337b:	c3                   	ret    

8010337c <install_trans>:

// Copy committed blocks from log to their home location
static void 
install_trans(void)
{
8010337c:	55                   	push   %ebp
8010337d:	89 e5                	mov    %esp,%ebp
8010337f:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103382:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103389:	e9 95 00 00 00       	jmp    80103423 <install_trans+0xa7>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
8010338e:	8b 15 94 22 11 80    	mov    0x80112294,%edx
80103394:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103397:	01 d0                	add    %edx,%eax
80103399:	83 c0 01             	add    $0x1,%eax
8010339c:	89 c2                	mov    %eax,%edx
8010339e:	a1 a4 22 11 80       	mov    0x801122a4,%eax
801033a3:	83 ec 08             	sub    $0x8,%esp
801033a6:	52                   	push   %edx
801033a7:	50                   	push   %eax
801033a8:	e8 09 ce ff ff       	call   801001b6 <bread>
801033ad:	83 c4 10             	add    $0x10,%esp
801033b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801033b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801033b6:	83 c0 10             	add    $0x10,%eax
801033b9:	8b 04 85 6c 22 11 80 	mov    -0x7feedd94(,%eax,4),%eax
801033c0:	89 c2                	mov    %eax,%edx
801033c2:	a1 a4 22 11 80       	mov    0x801122a4,%eax
801033c7:	83 ec 08             	sub    $0x8,%esp
801033ca:	52                   	push   %edx
801033cb:	50                   	push   %eax
801033cc:	e8 e5 cd ff ff       	call   801001b6 <bread>
801033d1:	83 c4 10             	add    $0x10,%esp
801033d4:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801033d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801033da:	8d 50 18             	lea    0x18(%eax),%edx
801033dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
801033e0:	83 c0 18             	add    $0x18,%eax
801033e3:	83 ec 04             	sub    $0x4,%esp
801033e6:	68 00 02 00 00       	push   $0x200
801033eb:	52                   	push   %edx
801033ec:	50                   	push   %eax
801033ed:	e8 65 20 00 00       	call   80105457 <memmove>
801033f2:	83 c4 10             	add    $0x10,%esp
    bwrite(dbuf);  // write dst to disk
801033f5:	83 ec 0c             	sub    $0xc,%esp
801033f8:	ff 75 ec             	pushl  -0x14(%ebp)
801033fb:	e8 ef cd ff ff       	call   801001ef <bwrite>
80103400:	83 c4 10             	add    $0x10,%esp
    brelse(lbuf); 
80103403:	83 ec 0c             	sub    $0xc,%esp
80103406:	ff 75 f0             	pushl  -0x10(%ebp)
80103409:	e8 20 ce ff ff       	call   8010022e <brelse>
8010340e:	83 c4 10             	add    $0x10,%esp
    brelse(dbuf);
80103411:	83 ec 0c             	sub    $0xc,%esp
80103414:	ff 75 ec             	pushl  -0x14(%ebp)
80103417:	e8 12 ce ff ff       	call   8010022e <brelse>
8010341c:	83 c4 10             	add    $0x10,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
8010341f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103423:	a1 a8 22 11 80       	mov    0x801122a8,%eax
80103428:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010342b:	0f 8f 5d ff ff ff    	jg     8010338e <install_trans+0x12>
  }
}
80103431:	90                   	nop
80103432:	c9                   	leave  
80103433:	c3                   	ret    

80103434 <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
80103434:	55                   	push   %ebp
80103435:	89 e5                	mov    %esp,%ebp
80103437:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
8010343a:	a1 94 22 11 80       	mov    0x80112294,%eax
8010343f:	89 c2                	mov    %eax,%edx
80103441:	a1 a4 22 11 80       	mov    0x801122a4,%eax
80103446:	83 ec 08             	sub    $0x8,%esp
80103449:	52                   	push   %edx
8010344a:	50                   	push   %eax
8010344b:	e8 66 cd ff ff       	call   801001b6 <bread>
80103450:	83 c4 10             	add    $0x10,%esp
80103453:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
80103456:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103459:	83 c0 18             	add    $0x18,%eax
8010345c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
8010345f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103462:	8b 00                	mov    (%eax),%eax
80103464:	a3 a8 22 11 80       	mov    %eax,0x801122a8
  for (i = 0; i < log.lh.n; i++) {
80103469:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103470:	eb 1b                	jmp    8010348d <read_head+0x59>
    log.lh.block[i] = lh->block[i];
80103472:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103475:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103478:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
8010347c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010347f:	83 c2 10             	add    $0x10,%edx
80103482:	89 04 95 6c 22 11 80 	mov    %eax,-0x7feedd94(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80103489:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010348d:	a1 a8 22 11 80       	mov    0x801122a8,%eax
80103492:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103495:	7f db                	jg     80103472 <read_head+0x3e>
  }
  brelse(buf);
80103497:	83 ec 0c             	sub    $0xc,%esp
8010349a:	ff 75 f0             	pushl  -0x10(%ebp)
8010349d:	e8 8c cd ff ff       	call   8010022e <brelse>
801034a2:	83 c4 10             	add    $0x10,%esp
}
801034a5:	90                   	nop
801034a6:	c9                   	leave  
801034a7:	c3                   	ret    

801034a8 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
801034a8:	55                   	push   %ebp
801034a9:	89 e5                	mov    %esp,%ebp
801034ab:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
801034ae:	a1 94 22 11 80       	mov    0x80112294,%eax
801034b3:	89 c2                	mov    %eax,%edx
801034b5:	a1 a4 22 11 80       	mov    0x801122a4,%eax
801034ba:	83 ec 08             	sub    $0x8,%esp
801034bd:	52                   	push   %edx
801034be:	50                   	push   %eax
801034bf:	e8 f2 cc ff ff       	call   801001b6 <bread>
801034c4:	83 c4 10             	add    $0x10,%esp
801034c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
801034ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
801034cd:	83 c0 18             	add    $0x18,%eax
801034d0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
801034d3:	8b 15 a8 22 11 80    	mov    0x801122a8,%edx
801034d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801034dc:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
801034de:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801034e5:	eb 1b                	jmp    80103502 <write_head+0x5a>
    hb->block[i] = log.lh.block[i];
801034e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801034ea:	83 c0 10             	add    $0x10,%eax
801034ed:	8b 0c 85 6c 22 11 80 	mov    -0x7feedd94(,%eax,4),%ecx
801034f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801034f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801034fa:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
801034fe:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103502:	a1 a8 22 11 80       	mov    0x801122a8,%eax
80103507:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010350a:	7f db                	jg     801034e7 <write_head+0x3f>
  }
  bwrite(buf);
8010350c:	83 ec 0c             	sub    $0xc,%esp
8010350f:	ff 75 f0             	pushl  -0x10(%ebp)
80103512:	e8 d8 cc ff ff       	call   801001ef <bwrite>
80103517:	83 c4 10             	add    $0x10,%esp
  brelse(buf);
8010351a:	83 ec 0c             	sub    $0xc,%esp
8010351d:	ff 75 f0             	pushl  -0x10(%ebp)
80103520:	e8 09 cd ff ff       	call   8010022e <brelse>
80103525:	83 c4 10             	add    $0x10,%esp
}
80103528:	90                   	nop
80103529:	c9                   	leave  
8010352a:	c3                   	ret    

8010352b <recover_from_log>:

static void
recover_from_log(void)
{
8010352b:	55                   	push   %ebp
8010352c:	89 e5                	mov    %esp,%ebp
8010352e:	83 ec 08             	sub    $0x8,%esp
  read_head();      
80103531:	e8 fe fe ff ff       	call   80103434 <read_head>
  install_trans(); // if committed, copy from log to disk
80103536:	e8 41 fe ff ff       	call   8010337c <install_trans>
  log.lh.n = 0;
8010353b:	c7 05 a8 22 11 80 00 	movl   $0x0,0x801122a8
80103542:	00 00 00 
  write_head(); // clear the log
80103545:	e8 5e ff ff ff       	call   801034a8 <write_head>
}
8010354a:	90                   	nop
8010354b:	c9                   	leave  
8010354c:	c3                   	ret    

8010354d <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
8010354d:	55                   	push   %ebp
8010354e:	89 e5                	mov    %esp,%ebp
80103550:	83 ec 08             	sub    $0x8,%esp
  acquire(&log.lock);
80103553:	83 ec 0c             	sub    $0xc,%esp
80103556:	68 60 22 11 80       	push   $0x80112260
8010355b:	e8 d5 1b 00 00       	call   80105135 <acquire>
80103560:	83 c4 10             	add    $0x10,%esp
  while(1){
    if(log.committing){
80103563:	a1 a0 22 11 80       	mov    0x801122a0,%eax
80103568:	85 c0                	test   %eax,%eax
8010356a:	74 17                	je     80103583 <begin_op+0x36>
      sleep(&log, &log.lock);
8010356c:	83 ec 08             	sub    $0x8,%esp
8010356f:	68 60 22 11 80       	push   $0x80112260
80103574:	68 60 22 11 80       	push   $0x80112260
80103579:	e8 cc 18 00 00       	call   80104e4a <sleep>
8010357e:	83 c4 10             	add    $0x10,%esp
80103581:	eb e0                	jmp    80103563 <begin_op+0x16>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103583:	8b 0d a8 22 11 80    	mov    0x801122a8,%ecx
80103589:	a1 9c 22 11 80       	mov    0x8011229c,%eax
8010358e:	8d 50 01             	lea    0x1(%eax),%edx
80103591:	89 d0                	mov    %edx,%eax
80103593:	c1 e0 02             	shl    $0x2,%eax
80103596:	01 d0                	add    %edx,%eax
80103598:	01 c0                	add    %eax,%eax
8010359a:	01 c8                	add    %ecx,%eax
8010359c:	83 f8 1e             	cmp    $0x1e,%eax
8010359f:	7e 17                	jle    801035b8 <begin_op+0x6b>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
801035a1:	83 ec 08             	sub    $0x8,%esp
801035a4:	68 60 22 11 80       	push   $0x80112260
801035a9:	68 60 22 11 80       	push   $0x80112260
801035ae:	e8 97 18 00 00       	call   80104e4a <sleep>
801035b3:	83 c4 10             	add    $0x10,%esp
801035b6:	eb ab                	jmp    80103563 <begin_op+0x16>
    } else {
      log.outstanding += 1;
801035b8:	a1 9c 22 11 80       	mov    0x8011229c,%eax
801035bd:	83 c0 01             	add    $0x1,%eax
801035c0:	a3 9c 22 11 80       	mov    %eax,0x8011229c
      release(&log.lock);
801035c5:	83 ec 0c             	sub    $0xc,%esp
801035c8:	68 60 22 11 80       	push   $0x80112260
801035cd:	e8 ca 1b 00 00       	call   8010519c <release>
801035d2:	83 c4 10             	add    $0x10,%esp
      break;
801035d5:	90                   	nop
    }
  }
}
801035d6:	90                   	nop
801035d7:	c9                   	leave  
801035d8:	c3                   	ret    

801035d9 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
801035d9:	55                   	push   %ebp
801035da:	89 e5                	mov    %esp,%ebp
801035dc:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;
801035df:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
801035e6:	83 ec 0c             	sub    $0xc,%esp
801035e9:	68 60 22 11 80       	push   $0x80112260
801035ee:	e8 42 1b 00 00       	call   80105135 <acquire>
801035f3:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
801035f6:	a1 9c 22 11 80       	mov    0x8011229c,%eax
801035fb:	83 e8 01             	sub    $0x1,%eax
801035fe:	a3 9c 22 11 80       	mov    %eax,0x8011229c
  if(log.committing)
80103603:	a1 a0 22 11 80       	mov    0x801122a0,%eax
80103608:	85 c0                	test   %eax,%eax
8010360a:	74 0d                	je     80103619 <end_op+0x40>
    panic("log.committing");
8010360c:	83 ec 0c             	sub    $0xc,%esp
8010360f:	68 f4 88 10 80       	push   $0x801088f4
80103614:	e8 4d cf ff ff       	call   80100566 <panic>
  if(log.outstanding == 0){
80103619:	a1 9c 22 11 80       	mov    0x8011229c,%eax
8010361e:	85 c0                	test   %eax,%eax
80103620:	75 13                	jne    80103635 <end_op+0x5c>
    do_commit = 1;
80103622:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
80103629:	c7 05 a0 22 11 80 01 	movl   $0x1,0x801122a0
80103630:	00 00 00 
80103633:	eb 10                	jmp    80103645 <end_op+0x6c>
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
80103635:	83 ec 0c             	sub    $0xc,%esp
80103638:	68 60 22 11 80       	push   $0x80112260
8010363d:	e8 f3 18 00 00       	call   80104f35 <wakeup>
80103642:	83 c4 10             	add    $0x10,%esp
  }
  release(&log.lock);
80103645:	83 ec 0c             	sub    $0xc,%esp
80103648:	68 60 22 11 80       	push   $0x80112260
8010364d:	e8 4a 1b 00 00       	call   8010519c <release>
80103652:	83 c4 10             	add    $0x10,%esp

  if(do_commit){
80103655:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103659:	74 3f                	je     8010369a <end_op+0xc1>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
8010365b:	e8 f5 00 00 00       	call   80103755 <commit>
    acquire(&log.lock);
80103660:	83 ec 0c             	sub    $0xc,%esp
80103663:	68 60 22 11 80       	push   $0x80112260
80103668:	e8 c8 1a 00 00       	call   80105135 <acquire>
8010366d:	83 c4 10             	add    $0x10,%esp
    log.committing = 0;
80103670:	c7 05 a0 22 11 80 00 	movl   $0x0,0x801122a0
80103677:	00 00 00 
    wakeup(&log);
8010367a:	83 ec 0c             	sub    $0xc,%esp
8010367d:	68 60 22 11 80       	push   $0x80112260
80103682:	e8 ae 18 00 00       	call   80104f35 <wakeup>
80103687:	83 c4 10             	add    $0x10,%esp
    release(&log.lock);
8010368a:	83 ec 0c             	sub    $0xc,%esp
8010368d:	68 60 22 11 80       	push   $0x80112260
80103692:	e8 05 1b 00 00       	call   8010519c <release>
80103697:	83 c4 10             	add    $0x10,%esp
  }
}
8010369a:	90                   	nop
8010369b:	c9                   	leave  
8010369c:	c3                   	ret    

8010369d <write_log>:

// Copy modified blocks from cache to log.
static void 
write_log(void)
{
8010369d:	55                   	push   %ebp
8010369e:	89 e5                	mov    %esp,%ebp
801036a0:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801036a3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801036aa:	e9 95 00 00 00       	jmp    80103744 <write_log+0xa7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801036af:	8b 15 94 22 11 80    	mov    0x80112294,%edx
801036b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036b8:	01 d0                	add    %edx,%eax
801036ba:	83 c0 01             	add    $0x1,%eax
801036bd:	89 c2                	mov    %eax,%edx
801036bf:	a1 a4 22 11 80       	mov    0x801122a4,%eax
801036c4:	83 ec 08             	sub    $0x8,%esp
801036c7:	52                   	push   %edx
801036c8:	50                   	push   %eax
801036c9:	e8 e8 ca ff ff       	call   801001b6 <bread>
801036ce:	83 c4 10             	add    $0x10,%esp
801036d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801036d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036d7:	83 c0 10             	add    $0x10,%eax
801036da:	8b 04 85 6c 22 11 80 	mov    -0x7feedd94(,%eax,4),%eax
801036e1:	89 c2                	mov    %eax,%edx
801036e3:	a1 a4 22 11 80       	mov    0x801122a4,%eax
801036e8:	83 ec 08             	sub    $0x8,%esp
801036eb:	52                   	push   %edx
801036ec:	50                   	push   %eax
801036ed:	e8 c4 ca ff ff       	call   801001b6 <bread>
801036f2:	83 c4 10             	add    $0x10,%esp
801036f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
801036f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801036fb:	8d 50 18             	lea    0x18(%eax),%edx
801036fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103701:	83 c0 18             	add    $0x18,%eax
80103704:	83 ec 04             	sub    $0x4,%esp
80103707:	68 00 02 00 00       	push   $0x200
8010370c:	52                   	push   %edx
8010370d:	50                   	push   %eax
8010370e:	e8 44 1d 00 00       	call   80105457 <memmove>
80103713:	83 c4 10             	add    $0x10,%esp
    bwrite(to);  // write the log
80103716:	83 ec 0c             	sub    $0xc,%esp
80103719:	ff 75 f0             	pushl  -0x10(%ebp)
8010371c:	e8 ce ca ff ff       	call   801001ef <bwrite>
80103721:	83 c4 10             	add    $0x10,%esp
    brelse(from); 
80103724:	83 ec 0c             	sub    $0xc,%esp
80103727:	ff 75 ec             	pushl  -0x14(%ebp)
8010372a:	e8 ff ca ff ff       	call   8010022e <brelse>
8010372f:	83 c4 10             	add    $0x10,%esp
    brelse(to);
80103732:	83 ec 0c             	sub    $0xc,%esp
80103735:	ff 75 f0             	pushl  -0x10(%ebp)
80103738:	e8 f1 ca ff ff       	call   8010022e <brelse>
8010373d:	83 c4 10             	add    $0x10,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
80103740:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103744:	a1 a8 22 11 80       	mov    0x801122a8,%eax
80103749:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010374c:	0f 8f 5d ff ff ff    	jg     801036af <write_log+0x12>
  }
}
80103752:	90                   	nop
80103753:	c9                   	leave  
80103754:	c3                   	ret    

80103755 <commit>:

static void
commit()
{
80103755:	55                   	push   %ebp
80103756:	89 e5                	mov    %esp,%ebp
80103758:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
8010375b:	a1 a8 22 11 80       	mov    0x801122a8,%eax
80103760:	85 c0                	test   %eax,%eax
80103762:	7e 1e                	jle    80103782 <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
80103764:	e8 34 ff ff ff       	call   8010369d <write_log>
    write_head();    // Write header to disk -- the real commit
80103769:	e8 3a fd ff ff       	call   801034a8 <write_head>
    install_trans(); // Now install writes to home locations
8010376e:	e8 09 fc ff ff       	call   8010337c <install_trans>
    log.lh.n = 0; 
80103773:	c7 05 a8 22 11 80 00 	movl   $0x0,0x801122a8
8010377a:	00 00 00 
    write_head();    // Erase the transaction from the log
8010377d:	e8 26 fd ff ff       	call   801034a8 <write_head>
  }
}
80103782:	90                   	nop
80103783:	c9                   	leave  
80103784:	c3                   	ret    

80103785 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103785:	55                   	push   %ebp
80103786:	89 e5                	mov    %esp,%ebp
80103788:	83 ec 18             	sub    $0x18,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
8010378b:	a1 a8 22 11 80       	mov    0x801122a8,%eax
80103790:	83 f8 1d             	cmp    $0x1d,%eax
80103793:	7f 12                	jg     801037a7 <log_write+0x22>
80103795:	a1 a8 22 11 80       	mov    0x801122a8,%eax
8010379a:	8b 15 98 22 11 80    	mov    0x80112298,%edx
801037a0:	83 ea 01             	sub    $0x1,%edx
801037a3:	39 d0                	cmp    %edx,%eax
801037a5:	7c 0d                	jl     801037b4 <log_write+0x2f>
    panic("too big a transaction");
801037a7:	83 ec 0c             	sub    $0xc,%esp
801037aa:	68 03 89 10 80       	push   $0x80108903
801037af:	e8 b2 cd ff ff       	call   80100566 <panic>
  if (log.outstanding < 1)
801037b4:	a1 9c 22 11 80       	mov    0x8011229c,%eax
801037b9:	85 c0                	test   %eax,%eax
801037bb:	7f 0d                	jg     801037ca <log_write+0x45>
    panic("log_write outside of trans");
801037bd:	83 ec 0c             	sub    $0xc,%esp
801037c0:	68 19 89 10 80       	push   $0x80108919
801037c5:	e8 9c cd ff ff       	call   80100566 <panic>

  acquire(&log.lock);
801037ca:	83 ec 0c             	sub    $0xc,%esp
801037cd:	68 60 22 11 80       	push   $0x80112260
801037d2:	e8 5e 19 00 00       	call   80105135 <acquire>
801037d7:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < log.lh.n; i++) {
801037da:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801037e1:	eb 1d                	jmp    80103800 <log_write+0x7b>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801037e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801037e6:	83 c0 10             	add    $0x10,%eax
801037e9:	8b 04 85 6c 22 11 80 	mov    -0x7feedd94(,%eax,4),%eax
801037f0:	89 c2                	mov    %eax,%edx
801037f2:	8b 45 08             	mov    0x8(%ebp),%eax
801037f5:	8b 40 08             	mov    0x8(%eax),%eax
801037f8:	39 c2                	cmp    %eax,%edx
801037fa:	74 10                	je     8010380c <log_write+0x87>
  for (i = 0; i < log.lh.n; i++) {
801037fc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103800:	a1 a8 22 11 80       	mov    0x801122a8,%eax
80103805:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103808:	7f d9                	jg     801037e3 <log_write+0x5e>
8010380a:	eb 01                	jmp    8010380d <log_write+0x88>
      break;
8010380c:	90                   	nop
  }
  log.lh.block[i] = b->blockno;
8010380d:	8b 45 08             	mov    0x8(%ebp),%eax
80103810:	8b 40 08             	mov    0x8(%eax),%eax
80103813:	89 c2                	mov    %eax,%edx
80103815:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103818:	83 c0 10             	add    $0x10,%eax
8010381b:	89 14 85 6c 22 11 80 	mov    %edx,-0x7feedd94(,%eax,4)
  if (i == log.lh.n)
80103822:	a1 a8 22 11 80       	mov    0x801122a8,%eax
80103827:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010382a:	75 0d                	jne    80103839 <log_write+0xb4>
    log.lh.n++;
8010382c:	a1 a8 22 11 80       	mov    0x801122a8,%eax
80103831:	83 c0 01             	add    $0x1,%eax
80103834:	a3 a8 22 11 80       	mov    %eax,0x801122a8
  b->flags |= B_DIRTY; // prevent eviction
80103839:	8b 45 08             	mov    0x8(%ebp),%eax
8010383c:	8b 00                	mov    (%eax),%eax
8010383e:	83 c8 04             	or     $0x4,%eax
80103841:	89 c2                	mov    %eax,%edx
80103843:	8b 45 08             	mov    0x8(%ebp),%eax
80103846:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
80103848:	83 ec 0c             	sub    $0xc,%esp
8010384b:	68 60 22 11 80       	push   $0x80112260
80103850:	e8 47 19 00 00       	call   8010519c <release>
80103855:	83 c4 10             	add    $0x10,%esp
}
80103858:	90                   	nop
80103859:	c9                   	leave  
8010385a:	c3                   	ret    

8010385b <v2p>:
8010385b:	55                   	push   %ebp
8010385c:	89 e5                	mov    %esp,%ebp
8010385e:	8b 45 08             	mov    0x8(%ebp),%eax
80103861:	05 00 00 00 80       	add    $0x80000000,%eax
80103866:	5d                   	pop    %ebp
80103867:	c3                   	ret    

80103868 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80103868:	55                   	push   %ebp
80103869:	89 e5                	mov    %esp,%ebp
8010386b:	8b 45 08             	mov    0x8(%ebp),%eax
8010386e:	05 00 00 00 80       	add    $0x80000000,%eax
80103873:	5d                   	pop    %ebp
80103874:	c3                   	ret    

80103875 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
80103875:	55                   	push   %ebp
80103876:	89 e5                	mov    %esp,%ebp
80103878:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010387b:	8b 55 08             	mov    0x8(%ebp),%edx
8010387e:	8b 45 0c             	mov    0xc(%ebp),%eax
80103881:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103884:	f0 87 02             	lock xchg %eax,(%edx)
80103887:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
8010388a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010388d:	c9                   	leave  
8010388e:	c3                   	ret    

8010388f <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
8010388f:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103893:	83 e4 f0             	and    $0xfffffff0,%esp
80103896:	ff 71 fc             	pushl  -0x4(%ecx)
80103899:	55                   	push   %ebp
8010389a:	89 e5                	mov    %esp,%ebp
8010389c:	51                   	push   %ecx
8010389d:	83 ec 04             	sub    $0x4,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801038a0:	83 ec 08             	sub    $0x8,%esp
801038a3:	68 00 00 40 80       	push   $0x80400000
801038a8:	68 3c 52 11 80       	push   $0x8011523c
801038ad:	e8 7d f2 ff ff       	call   80102b2f <kinit1>
801038b2:	83 c4 10             	add    $0x10,%esp
  kvmalloc();      // kernel page table
801038b5:	e8 4a 46 00 00       	call   80107f04 <kvmalloc>
  mpinit();        // collect info about this machine
801038ba:	e8 43 04 00 00       	call   80103d02 <mpinit>
  lapicinit();
801038bf:	e8 ea f5 ff ff       	call   80102eae <lapicinit>
  seginit();       // set up segments
801038c4:	e8 e4 3f 00 00       	call   801078ad <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
801038c9:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801038cf:	0f b6 00             	movzbl (%eax),%eax
801038d2:	0f b6 c0             	movzbl %al,%eax
801038d5:	83 ec 08             	sub    $0x8,%esp
801038d8:	50                   	push   %eax
801038d9:	68 34 89 10 80       	push   $0x80108934
801038de:	e8 e3 ca ff ff       	call   801003c6 <cprintf>
801038e3:	83 c4 10             	add    $0x10,%esp
  picinit();       // interrupt controller
801038e6:	e8 6d 06 00 00       	call   80103f58 <picinit>
  ioapicinit();    // another interrupt controller
801038eb:	e8 34 f1 ff ff       	call   80102a24 <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
801038f0:	e8 24 d2 ff ff       	call   80100b19 <consoleinit>
  uartinit();      // serial port
801038f5:	e8 0f 33 00 00       	call   80106c09 <uartinit>
  pinit();         // process table
801038fa:	e8 56 0b 00 00       	call   80104455 <pinit>
  tvinit();        // trap vectors
801038ff:	e8 cf 2e 00 00       	call   801067d3 <tvinit>
  binit();         // buffer cache
80103904:	e8 2b c7 ff ff       	call   80100034 <binit>
  fileinit();      // file table
80103909:	e8 67 d6 ff ff       	call   80100f75 <fileinit>
  ideinit();       // disk
8010390e:	e8 19 ed ff ff       	call   8010262c <ideinit>
  if(!ismp)
80103913:	a1 44 23 11 80       	mov    0x80112344,%eax
80103918:	85 c0                	test   %eax,%eax
8010391a:	75 05                	jne    80103921 <main+0x92>
    timerinit();   // uniprocessor timer
8010391c:	e8 0f 2e 00 00       	call   80106730 <timerinit>
  startothers();   // start other processors
80103921:	e8 7f 00 00 00       	call   801039a5 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103926:	83 ec 08             	sub    $0x8,%esp
80103929:	68 00 00 00 8e       	push   $0x8e000000
8010392e:	68 00 00 40 80       	push   $0x80400000
80103933:	e8 30 f2 ff ff       	call   80102b68 <kinit2>
80103938:	83 c4 10             	add    $0x10,%esp
  userinit();      // first user process
8010393b:	e8 09 0c 00 00       	call   80104549 <userinit>
  // Finish setting up this processor in mpmain.
  mpmain();
80103940:	e8 1a 00 00 00       	call   8010395f <mpmain>

80103945 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80103945:	55                   	push   %ebp
80103946:	89 e5                	mov    %esp,%ebp
80103948:	83 ec 08             	sub    $0x8,%esp
  switchkvm(); 
8010394b:	e8 cc 45 00 00       	call   80107f1c <switchkvm>
  seginit();
80103950:	e8 58 3f 00 00       	call   801078ad <seginit>
  lapicinit();
80103955:	e8 54 f5 ff ff       	call   80102eae <lapicinit>
  mpmain();
8010395a:	e8 00 00 00 00       	call   8010395f <mpmain>

8010395f <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
8010395f:	55                   	push   %ebp
80103960:	89 e5                	mov    %esp,%ebp
80103962:	83 ec 08             	sub    $0x8,%esp
  cprintf("cpu%d: starting\n", cpu->id);
80103965:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010396b:	0f b6 00             	movzbl (%eax),%eax
8010396e:	0f b6 c0             	movzbl %al,%eax
80103971:	83 ec 08             	sub    $0x8,%esp
80103974:	50                   	push   %eax
80103975:	68 4b 89 10 80       	push   $0x8010894b
8010397a:	e8 47 ca ff ff       	call   801003c6 <cprintf>
8010397f:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
80103982:	e8 c2 2f 00 00       	call   80106949 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
80103987:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010398d:	05 a8 00 00 00       	add    $0xa8,%eax
80103992:	83 ec 08             	sub    $0x8,%esp
80103995:	6a 01                	push   $0x1
80103997:	50                   	push   %eax
80103998:	e8 d8 fe ff ff       	call   80103875 <xchg>
8010399d:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
801039a0:	e8 63 12 00 00       	call   80104c08 <scheduler>

801039a5 <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
801039a5:	55                   	push   %ebp
801039a6:	89 e5                	mov    %esp,%ebp
801039a8:	53                   	push   %ebx
801039a9:	83 ec 14             	sub    $0x14,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
801039ac:	68 00 70 00 00       	push   $0x7000
801039b1:	e8 b2 fe ff ff       	call   80103868 <p2v>
801039b6:	83 c4 04             	add    $0x4,%esp
801039b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801039bc:	b8 8a 00 00 00       	mov    $0x8a,%eax
801039c1:	83 ec 04             	sub    $0x4,%esp
801039c4:	50                   	push   %eax
801039c5:	68 0c b5 10 80       	push   $0x8010b50c
801039ca:	ff 75 f0             	pushl  -0x10(%ebp)
801039cd:	e8 85 1a 00 00       	call   80105457 <memmove>
801039d2:	83 c4 10             	add    $0x10,%esp

  for(c = cpus; c < cpus+ncpu; c++){
801039d5:	c7 45 f4 60 23 11 80 	movl   $0x80112360,-0xc(%ebp)
801039dc:	e9 90 00 00 00       	jmp    80103a71 <startothers+0xcc>
    if(c == cpus+cpunum())  // We've started already.
801039e1:	e8 e6 f5 ff ff       	call   80102fcc <cpunum>
801039e6:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
801039ec:	05 60 23 11 80       	add    $0x80112360,%eax
801039f1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801039f4:	74 73                	je     80103a69 <startothers+0xc4>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801039f6:	e8 6b f2 ff ff       	call   80102c66 <kalloc>
801039fb:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
801039fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a01:	83 e8 04             	sub    $0x4,%eax
80103a04:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103a07:	81 c2 00 10 00 00    	add    $0x1000,%edx
80103a0d:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
80103a0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a12:	83 e8 08             	sub    $0x8,%eax
80103a15:	c7 00 45 39 10 80    	movl   $0x80103945,(%eax)
    *(int**)(code-12) = (void *) v2p(entrypgdir);
80103a1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a1e:	8d 58 f4             	lea    -0xc(%eax),%ebx
80103a21:	83 ec 0c             	sub    $0xc,%esp
80103a24:	68 00 a0 10 80       	push   $0x8010a000
80103a29:	e8 2d fe ff ff       	call   8010385b <v2p>
80103a2e:	83 c4 10             	add    $0x10,%esp
80103a31:	89 03                	mov    %eax,(%ebx)

    lapicstartap(c->id, v2p(code));
80103a33:	83 ec 0c             	sub    $0xc,%esp
80103a36:	ff 75 f0             	pushl  -0x10(%ebp)
80103a39:	e8 1d fe ff ff       	call   8010385b <v2p>
80103a3e:	83 c4 10             	add    $0x10,%esp
80103a41:	89 c2                	mov    %eax,%edx
80103a43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a46:	0f b6 00             	movzbl (%eax),%eax
80103a49:	0f b6 c0             	movzbl %al,%eax
80103a4c:	83 ec 08             	sub    $0x8,%esp
80103a4f:	52                   	push   %edx
80103a50:	50                   	push   %eax
80103a51:	e8 f0 f5 ff ff       	call   80103046 <lapicstartap>
80103a56:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103a59:	90                   	nop
80103a5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a5d:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80103a63:	85 c0                	test   %eax,%eax
80103a65:	74 f3                	je     80103a5a <startothers+0xb5>
80103a67:	eb 01                	jmp    80103a6a <startothers+0xc5>
      continue;
80103a69:	90                   	nop
  for(c = cpus; c < cpus+ncpu; c++){
80103a6a:	81 45 f4 bc 00 00 00 	addl   $0xbc,-0xc(%ebp)
80103a71:	a1 40 29 11 80       	mov    0x80112940,%eax
80103a76:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103a7c:	05 60 23 11 80       	add    $0x80112360,%eax
80103a81:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103a84:	0f 87 57 ff ff ff    	ja     801039e1 <startothers+0x3c>
      ;
  }
}
80103a8a:	90                   	nop
80103a8b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a8e:	c9                   	leave  
80103a8f:	c3                   	ret    

80103a90 <p2v>:
80103a90:	55                   	push   %ebp
80103a91:	89 e5                	mov    %esp,%ebp
80103a93:	8b 45 08             	mov    0x8(%ebp),%eax
80103a96:	05 00 00 00 80       	add    $0x80000000,%eax
80103a9b:	5d                   	pop    %ebp
80103a9c:	c3                   	ret    

80103a9d <inb>:
{
80103a9d:	55                   	push   %ebp
80103a9e:	89 e5                	mov    %esp,%ebp
80103aa0:	83 ec 14             	sub    $0x14,%esp
80103aa3:	8b 45 08             	mov    0x8(%ebp),%eax
80103aa6:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103aaa:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80103aae:	89 c2                	mov    %eax,%edx
80103ab0:	ec                   	in     (%dx),%al
80103ab1:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103ab4:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103ab8:	c9                   	leave  
80103ab9:	c3                   	ret    

80103aba <outb>:
{
80103aba:	55                   	push   %ebp
80103abb:	89 e5                	mov    %esp,%ebp
80103abd:	83 ec 08             	sub    $0x8,%esp
80103ac0:	8b 55 08             	mov    0x8(%ebp),%edx
80103ac3:	8b 45 0c             	mov    0xc(%ebp),%eax
80103ac6:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103aca:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103acd:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103ad1:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103ad5:	ee                   	out    %al,(%dx)
}
80103ad6:	90                   	nop
80103ad7:	c9                   	leave  
80103ad8:	c3                   	ret    

80103ad9 <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
80103ad9:	55                   	push   %ebp
80103ada:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
80103adc:	a1 44 b6 10 80       	mov    0x8010b644,%eax
80103ae1:	89 c2                	mov    %eax,%edx
80103ae3:	b8 60 23 11 80       	mov    $0x80112360,%eax
80103ae8:	29 c2                	sub    %eax,%edx
80103aea:	89 d0                	mov    %edx,%eax
80103aec:	c1 f8 02             	sar    $0x2,%eax
80103aef:	69 c0 cf 46 7d 67    	imul   $0x677d46cf,%eax,%eax
}
80103af5:	5d                   	pop    %ebp
80103af6:	c3                   	ret    

80103af7 <sum>:

static uchar
sum(uchar *addr, int len)
{
80103af7:	55                   	push   %ebp
80103af8:	89 e5                	mov    %esp,%ebp
80103afa:	83 ec 10             	sub    $0x10,%esp
  int i, sum;
  
  sum = 0;
80103afd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
80103b04:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103b0b:	eb 15                	jmp    80103b22 <sum+0x2b>
    sum += addr[i];
80103b0d:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103b10:	8b 45 08             	mov    0x8(%ebp),%eax
80103b13:	01 d0                	add    %edx,%eax
80103b15:	0f b6 00             	movzbl (%eax),%eax
80103b18:	0f b6 c0             	movzbl %al,%eax
80103b1b:	01 45 f8             	add    %eax,-0x8(%ebp)
  for(i=0; i<len; i++)
80103b1e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103b22:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103b25:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103b28:	7c e3                	jl     80103b0d <sum+0x16>
  return sum;
80103b2a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103b2d:	c9                   	leave  
80103b2e:	c3                   	ret    

80103b2f <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103b2f:	55                   	push   %ebp
80103b30:	89 e5                	mov    %esp,%ebp
80103b32:	83 ec 18             	sub    $0x18,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
80103b35:	ff 75 08             	pushl  0x8(%ebp)
80103b38:	e8 53 ff ff ff       	call   80103a90 <p2v>
80103b3d:	83 c4 04             	add    $0x4,%esp
80103b40:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
80103b43:	8b 55 0c             	mov    0xc(%ebp),%edx
80103b46:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b49:	01 d0                	add    %edx,%eax
80103b4b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80103b4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b51:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103b54:	eb 36                	jmp    80103b8c <mpsearch1+0x5d>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103b56:	83 ec 04             	sub    $0x4,%esp
80103b59:	6a 04                	push   $0x4
80103b5b:	68 5c 89 10 80       	push   $0x8010895c
80103b60:	ff 75 f4             	pushl  -0xc(%ebp)
80103b63:	e8 97 18 00 00       	call   801053ff <memcmp>
80103b68:	83 c4 10             	add    $0x10,%esp
80103b6b:	85 c0                	test   %eax,%eax
80103b6d:	75 19                	jne    80103b88 <mpsearch1+0x59>
80103b6f:	83 ec 08             	sub    $0x8,%esp
80103b72:	6a 10                	push   $0x10
80103b74:	ff 75 f4             	pushl  -0xc(%ebp)
80103b77:	e8 7b ff ff ff       	call   80103af7 <sum>
80103b7c:	83 c4 10             	add    $0x10,%esp
80103b7f:	84 c0                	test   %al,%al
80103b81:	75 05                	jne    80103b88 <mpsearch1+0x59>
      return (struct mp*)p;
80103b83:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b86:	eb 11                	jmp    80103b99 <mpsearch1+0x6a>
  for(p = addr; p < e; p += sizeof(struct mp))
80103b88:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80103b8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b8f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103b92:	72 c2                	jb     80103b56 <mpsearch1+0x27>
  return 0;
80103b94:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103b99:	c9                   	leave  
80103b9a:	c3                   	ret    

80103b9b <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103b9b:	55                   	push   %ebp
80103b9c:	89 e5                	mov    %esp,%ebp
80103b9e:	83 ec 18             	sub    $0x18,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103ba1:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103ba8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bab:	83 c0 0f             	add    $0xf,%eax
80103bae:	0f b6 00             	movzbl (%eax),%eax
80103bb1:	0f b6 c0             	movzbl %al,%eax
80103bb4:	c1 e0 08             	shl    $0x8,%eax
80103bb7:	89 c2                	mov    %eax,%edx
80103bb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bbc:	83 c0 0e             	add    $0xe,%eax
80103bbf:	0f b6 00             	movzbl (%eax),%eax
80103bc2:	0f b6 c0             	movzbl %al,%eax
80103bc5:	09 d0                	or     %edx,%eax
80103bc7:	c1 e0 04             	shl    $0x4,%eax
80103bca:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103bcd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103bd1:	74 21                	je     80103bf4 <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
80103bd3:	83 ec 08             	sub    $0x8,%esp
80103bd6:	68 00 04 00 00       	push   $0x400
80103bdb:	ff 75 f0             	pushl  -0x10(%ebp)
80103bde:	e8 4c ff ff ff       	call   80103b2f <mpsearch1>
80103be3:	83 c4 10             	add    $0x10,%esp
80103be6:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103be9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103bed:	74 51                	je     80103c40 <mpsearch+0xa5>
      return mp;
80103bef:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103bf2:	eb 61                	jmp    80103c55 <mpsearch+0xba>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103bf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bf7:	83 c0 14             	add    $0x14,%eax
80103bfa:	0f b6 00             	movzbl (%eax),%eax
80103bfd:	0f b6 c0             	movzbl %al,%eax
80103c00:	c1 e0 08             	shl    $0x8,%eax
80103c03:	89 c2                	mov    %eax,%edx
80103c05:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c08:	83 c0 13             	add    $0x13,%eax
80103c0b:	0f b6 00             	movzbl (%eax),%eax
80103c0e:	0f b6 c0             	movzbl %al,%eax
80103c11:	09 d0                	or     %edx,%eax
80103c13:	c1 e0 0a             	shl    $0xa,%eax
80103c16:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103c19:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c1c:	2d 00 04 00 00       	sub    $0x400,%eax
80103c21:	83 ec 08             	sub    $0x8,%esp
80103c24:	68 00 04 00 00       	push   $0x400
80103c29:	50                   	push   %eax
80103c2a:	e8 00 ff ff ff       	call   80103b2f <mpsearch1>
80103c2f:	83 c4 10             	add    $0x10,%esp
80103c32:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103c35:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103c39:	74 05                	je     80103c40 <mpsearch+0xa5>
      return mp;
80103c3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103c3e:	eb 15                	jmp    80103c55 <mpsearch+0xba>
  }
  return mpsearch1(0xF0000, 0x10000);
80103c40:	83 ec 08             	sub    $0x8,%esp
80103c43:	68 00 00 01 00       	push   $0x10000
80103c48:	68 00 00 0f 00       	push   $0xf0000
80103c4d:	e8 dd fe ff ff       	call   80103b2f <mpsearch1>
80103c52:	83 c4 10             	add    $0x10,%esp
}
80103c55:	c9                   	leave  
80103c56:	c3                   	ret    

80103c57 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103c57:	55                   	push   %ebp
80103c58:	89 e5                	mov    %esp,%ebp
80103c5a:	83 ec 18             	sub    $0x18,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103c5d:	e8 39 ff ff ff       	call   80103b9b <mpsearch>
80103c62:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103c65:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103c69:	74 0a                	je     80103c75 <mpconfig+0x1e>
80103c6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c6e:	8b 40 04             	mov    0x4(%eax),%eax
80103c71:	85 c0                	test   %eax,%eax
80103c73:	75 0a                	jne    80103c7f <mpconfig+0x28>
    return 0;
80103c75:	b8 00 00 00 00       	mov    $0x0,%eax
80103c7a:	e9 81 00 00 00       	jmp    80103d00 <mpconfig+0xa9>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
80103c7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c82:	8b 40 04             	mov    0x4(%eax),%eax
80103c85:	83 ec 0c             	sub    $0xc,%esp
80103c88:	50                   	push   %eax
80103c89:	e8 02 fe ff ff       	call   80103a90 <p2v>
80103c8e:	83 c4 10             	add    $0x10,%esp
80103c91:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103c94:	83 ec 04             	sub    $0x4,%esp
80103c97:	6a 04                	push   $0x4
80103c99:	68 61 89 10 80       	push   $0x80108961
80103c9e:	ff 75 f0             	pushl  -0x10(%ebp)
80103ca1:	e8 59 17 00 00       	call   801053ff <memcmp>
80103ca6:	83 c4 10             	add    $0x10,%esp
80103ca9:	85 c0                	test   %eax,%eax
80103cab:	74 07                	je     80103cb4 <mpconfig+0x5d>
    return 0;
80103cad:	b8 00 00 00 00       	mov    $0x0,%eax
80103cb2:	eb 4c                	jmp    80103d00 <mpconfig+0xa9>
  if(conf->version != 1 && conf->version != 4)
80103cb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103cb7:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103cbb:	3c 01                	cmp    $0x1,%al
80103cbd:	74 12                	je     80103cd1 <mpconfig+0x7a>
80103cbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103cc2:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103cc6:	3c 04                	cmp    $0x4,%al
80103cc8:	74 07                	je     80103cd1 <mpconfig+0x7a>
    return 0;
80103cca:	b8 00 00 00 00       	mov    $0x0,%eax
80103ccf:	eb 2f                	jmp    80103d00 <mpconfig+0xa9>
  if(sum((uchar*)conf, conf->length) != 0)
80103cd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103cd4:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103cd8:	0f b7 c0             	movzwl %ax,%eax
80103cdb:	83 ec 08             	sub    $0x8,%esp
80103cde:	50                   	push   %eax
80103cdf:	ff 75 f0             	pushl  -0x10(%ebp)
80103ce2:	e8 10 fe ff ff       	call   80103af7 <sum>
80103ce7:	83 c4 10             	add    $0x10,%esp
80103cea:	84 c0                	test   %al,%al
80103cec:	74 07                	je     80103cf5 <mpconfig+0x9e>
    return 0;
80103cee:	b8 00 00 00 00       	mov    $0x0,%eax
80103cf3:	eb 0b                	jmp    80103d00 <mpconfig+0xa9>
  *pmp = mp;
80103cf5:	8b 45 08             	mov    0x8(%ebp),%eax
80103cf8:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103cfb:	89 10                	mov    %edx,(%eax)
  return conf;
80103cfd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103d00:	c9                   	leave  
80103d01:	c3                   	ret    

80103d02 <mpinit>:

void
mpinit(void)
{
80103d02:	55                   	push   %ebp
80103d03:	89 e5                	mov    %esp,%ebp
80103d05:	83 ec 28             	sub    $0x28,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
80103d08:	c7 05 44 b6 10 80 60 	movl   $0x80112360,0x8010b644
80103d0f:	23 11 80 
  if((conf = mpconfig(&mp)) == 0)
80103d12:	83 ec 0c             	sub    $0xc,%esp
80103d15:	8d 45 e0             	lea    -0x20(%ebp),%eax
80103d18:	50                   	push   %eax
80103d19:	e8 39 ff ff ff       	call   80103c57 <mpconfig>
80103d1e:	83 c4 10             	add    $0x10,%esp
80103d21:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103d24:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103d28:	0f 84 96 01 00 00    	je     80103ec4 <mpinit+0x1c2>
    return;
  ismp = 1;
80103d2e:	c7 05 44 23 11 80 01 	movl   $0x1,0x80112344
80103d35:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
80103d38:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d3b:	8b 40 24             	mov    0x24(%eax),%eax
80103d3e:	a3 5c 22 11 80       	mov    %eax,0x8011225c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103d43:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d46:	83 c0 2c             	add    $0x2c,%eax
80103d49:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103d4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d4f:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103d53:	0f b7 d0             	movzwl %ax,%edx
80103d56:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d59:	01 d0                	add    %edx,%eax
80103d5b:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103d5e:	e9 f2 00 00 00       	jmp    80103e55 <mpinit+0x153>
    switch(*p){
80103d63:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d66:	0f b6 00             	movzbl (%eax),%eax
80103d69:	0f b6 c0             	movzbl %al,%eax
80103d6c:	83 f8 04             	cmp    $0x4,%eax
80103d6f:	0f 87 bc 00 00 00    	ja     80103e31 <mpinit+0x12f>
80103d75:	8b 04 85 a4 89 10 80 	mov    -0x7fef765c(,%eax,4),%eax
80103d7c:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
80103d7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d81:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu != proc->apicid){
80103d84:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103d87:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103d8b:	0f b6 d0             	movzbl %al,%edx
80103d8e:	a1 40 29 11 80       	mov    0x80112940,%eax
80103d93:	39 c2                	cmp    %eax,%edx
80103d95:	74 2b                	je     80103dc2 <mpinit+0xc0>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
80103d97:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103d9a:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103d9e:	0f b6 d0             	movzbl %al,%edx
80103da1:	a1 40 29 11 80       	mov    0x80112940,%eax
80103da6:	83 ec 04             	sub    $0x4,%esp
80103da9:	52                   	push   %edx
80103daa:	50                   	push   %eax
80103dab:	68 66 89 10 80       	push   $0x80108966
80103db0:	e8 11 c6 ff ff       	call   801003c6 <cprintf>
80103db5:	83 c4 10             	add    $0x10,%esp
        ismp = 0;
80103db8:	c7 05 44 23 11 80 00 	movl   $0x0,0x80112344
80103dbf:	00 00 00 
      }
      if(proc->flags & MPBOOT)
80103dc2:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103dc5:	0f b6 40 03          	movzbl 0x3(%eax),%eax
80103dc9:	0f b6 c0             	movzbl %al,%eax
80103dcc:	83 e0 02             	and    $0x2,%eax
80103dcf:	85 c0                	test   %eax,%eax
80103dd1:	74 15                	je     80103de8 <mpinit+0xe6>
        bcpu = &cpus[ncpu];
80103dd3:	a1 40 29 11 80       	mov    0x80112940,%eax
80103dd8:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103dde:	05 60 23 11 80       	add    $0x80112360,%eax
80103de3:	a3 44 b6 10 80       	mov    %eax,0x8010b644
      cpus[ncpu].id = ncpu;
80103de8:	a1 40 29 11 80       	mov    0x80112940,%eax
80103ded:	8b 15 40 29 11 80    	mov    0x80112940,%edx
80103df3:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103df9:	05 60 23 11 80       	add    $0x80112360,%eax
80103dfe:	88 10                	mov    %dl,(%eax)
      ncpu++;
80103e00:	a1 40 29 11 80       	mov    0x80112940,%eax
80103e05:	83 c0 01             	add    $0x1,%eax
80103e08:	a3 40 29 11 80       	mov    %eax,0x80112940
      p += sizeof(struct mpproc);
80103e0d:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80103e11:	eb 42                	jmp    80103e55 <mpinit+0x153>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80103e13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e16:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
80103e19:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103e1c:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103e20:	a2 40 23 11 80       	mov    %al,0x80112340
      p += sizeof(struct mpioapic);
80103e25:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103e29:	eb 2a                	jmp    80103e55 <mpinit+0x153>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103e2b:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103e2f:	eb 24                	jmp    80103e55 <mpinit+0x153>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
80103e31:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e34:	0f b6 00             	movzbl (%eax),%eax
80103e37:	0f b6 c0             	movzbl %al,%eax
80103e3a:	83 ec 08             	sub    $0x8,%esp
80103e3d:	50                   	push   %eax
80103e3e:	68 84 89 10 80       	push   $0x80108984
80103e43:	e8 7e c5 ff ff       	call   801003c6 <cprintf>
80103e48:	83 c4 10             	add    $0x10,%esp
      ismp = 0;
80103e4b:	c7 05 44 23 11 80 00 	movl   $0x0,0x80112344
80103e52:	00 00 00 
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103e55:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e58:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103e5b:	0f 82 02 ff ff ff    	jb     80103d63 <mpinit+0x61>
    }
  }
  if(!ismp){
80103e61:	a1 44 23 11 80       	mov    0x80112344,%eax
80103e66:	85 c0                	test   %eax,%eax
80103e68:	75 1d                	jne    80103e87 <mpinit+0x185>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80103e6a:	c7 05 40 29 11 80 01 	movl   $0x1,0x80112940
80103e71:	00 00 00 
    lapic = 0;
80103e74:	c7 05 5c 22 11 80 00 	movl   $0x0,0x8011225c
80103e7b:	00 00 00 
    ioapicid = 0;
80103e7e:	c6 05 40 23 11 80 00 	movb   $0x0,0x80112340
    return;
80103e85:	eb 3e                	jmp    80103ec5 <mpinit+0x1c3>
  }

  if(mp->imcrp){
80103e87:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103e8a:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80103e8e:	84 c0                	test   %al,%al
80103e90:	74 33                	je     80103ec5 <mpinit+0x1c3>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80103e92:	83 ec 08             	sub    $0x8,%esp
80103e95:	6a 70                	push   $0x70
80103e97:	6a 22                	push   $0x22
80103e99:	e8 1c fc ff ff       	call   80103aba <outb>
80103e9e:	83 c4 10             	add    $0x10,%esp
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103ea1:	83 ec 0c             	sub    $0xc,%esp
80103ea4:	6a 23                	push   $0x23
80103ea6:	e8 f2 fb ff ff       	call   80103a9d <inb>
80103eab:	83 c4 10             	add    $0x10,%esp
80103eae:	83 c8 01             	or     $0x1,%eax
80103eb1:	0f b6 c0             	movzbl %al,%eax
80103eb4:	83 ec 08             	sub    $0x8,%esp
80103eb7:	50                   	push   %eax
80103eb8:	6a 23                	push   $0x23
80103eba:	e8 fb fb ff ff       	call   80103aba <outb>
80103ebf:	83 c4 10             	add    $0x10,%esp
80103ec2:	eb 01                	jmp    80103ec5 <mpinit+0x1c3>
    return;
80103ec4:	90                   	nop
  }
}
80103ec5:	c9                   	leave  
80103ec6:	c3                   	ret    

80103ec7 <outb>:
{
80103ec7:	55                   	push   %ebp
80103ec8:	89 e5                	mov    %esp,%ebp
80103eca:	83 ec 08             	sub    $0x8,%esp
80103ecd:	8b 55 08             	mov    0x8(%ebp),%edx
80103ed0:	8b 45 0c             	mov    0xc(%ebp),%eax
80103ed3:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103ed7:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103eda:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103ede:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103ee2:	ee                   	out    %al,(%dx)
}
80103ee3:	90                   	nop
80103ee4:	c9                   	leave  
80103ee5:	c3                   	ret    

80103ee6 <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
80103ee6:	55                   	push   %ebp
80103ee7:	89 e5                	mov    %esp,%ebp
80103ee9:	83 ec 04             	sub    $0x4,%esp
80103eec:	8b 45 08             	mov    0x8(%ebp),%eax
80103eef:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
80103ef3:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103ef7:	66 a3 00 b0 10 80    	mov    %ax,0x8010b000
  outb(IO_PIC1+1, mask);
80103efd:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103f01:	0f b6 c0             	movzbl %al,%eax
80103f04:	50                   	push   %eax
80103f05:	6a 21                	push   $0x21
80103f07:	e8 bb ff ff ff       	call   80103ec7 <outb>
80103f0c:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, mask >> 8);
80103f0f:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103f13:	66 c1 e8 08          	shr    $0x8,%ax
80103f17:	0f b6 c0             	movzbl %al,%eax
80103f1a:	50                   	push   %eax
80103f1b:	68 a1 00 00 00       	push   $0xa1
80103f20:	e8 a2 ff ff ff       	call   80103ec7 <outb>
80103f25:	83 c4 08             	add    $0x8,%esp
}
80103f28:	90                   	nop
80103f29:	c9                   	leave  
80103f2a:	c3                   	ret    

80103f2b <picenable>:

void
picenable(int irq)
{
80103f2b:	55                   	push   %ebp
80103f2c:	89 e5                	mov    %esp,%ebp
  picsetmask(irqmask & ~(1<<irq));
80103f2e:	8b 45 08             	mov    0x8(%ebp),%eax
80103f31:	ba 01 00 00 00       	mov    $0x1,%edx
80103f36:	89 c1                	mov    %eax,%ecx
80103f38:	d3 e2                	shl    %cl,%edx
80103f3a:	89 d0                	mov    %edx,%eax
80103f3c:	f7 d0                	not    %eax
80103f3e:	89 c2                	mov    %eax,%edx
80103f40:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80103f47:	21 d0                	and    %edx,%eax
80103f49:	0f b7 c0             	movzwl %ax,%eax
80103f4c:	50                   	push   %eax
80103f4d:	e8 94 ff ff ff       	call   80103ee6 <picsetmask>
80103f52:	83 c4 04             	add    $0x4,%esp
}
80103f55:	90                   	nop
80103f56:	c9                   	leave  
80103f57:	c3                   	ret    

80103f58 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80103f58:	55                   	push   %ebp
80103f59:	89 e5                	mov    %esp,%ebp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80103f5b:	68 ff 00 00 00       	push   $0xff
80103f60:	6a 21                	push   $0x21
80103f62:	e8 60 ff ff ff       	call   80103ec7 <outb>
80103f67:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, 0xFF);
80103f6a:	68 ff 00 00 00       	push   $0xff
80103f6f:	68 a1 00 00 00       	push   $0xa1
80103f74:	e8 4e ff ff ff       	call   80103ec7 <outb>
80103f79:	83 c4 08             	add    $0x8,%esp

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
80103f7c:	6a 11                	push   $0x11
80103f7e:	6a 20                	push   $0x20
80103f80:	e8 42 ff ff ff       	call   80103ec7 <outb>
80103f85:	83 c4 08             	add    $0x8,%esp

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
80103f88:	6a 20                	push   $0x20
80103f8a:	6a 21                	push   $0x21
80103f8c:	e8 36 ff ff ff       	call   80103ec7 <outb>
80103f91:	83 c4 08             	add    $0x8,%esp

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
80103f94:	6a 04                	push   $0x4
80103f96:	6a 21                	push   $0x21
80103f98:	e8 2a ff ff ff       	call   80103ec7 <outb>
80103f9d:	83 c4 08             	add    $0x8,%esp
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
80103fa0:	6a 03                	push   $0x3
80103fa2:	6a 21                	push   $0x21
80103fa4:	e8 1e ff ff ff       	call   80103ec7 <outb>
80103fa9:	83 c4 08             	add    $0x8,%esp

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
80103fac:	6a 11                	push   $0x11
80103fae:	68 a0 00 00 00       	push   $0xa0
80103fb3:	e8 0f ff ff ff       	call   80103ec7 <outb>
80103fb8:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
80103fbb:	6a 28                	push   $0x28
80103fbd:	68 a1 00 00 00       	push   $0xa1
80103fc2:	e8 00 ff ff ff       	call   80103ec7 <outb>
80103fc7:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
80103fca:	6a 02                	push   $0x2
80103fcc:	68 a1 00 00 00       	push   $0xa1
80103fd1:	e8 f1 fe ff ff       	call   80103ec7 <outb>
80103fd6:	83 c4 08             	add    $0x8,%esp
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
80103fd9:	6a 03                	push   $0x3
80103fdb:	68 a1 00 00 00       	push   $0xa1
80103fe0:	e8 e2 fe ff ff       	call   80103ec7 <outb>
80103fe5:	83 c4 08             	add    $0x8,%esp

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
80103fe8:	6a 68                	push   $0x68
80103fea:	6a 20                	push   $0x20
80103fec:	e8 d6 fe ff ff       	call   80103ec7 <outb>
80103ff1:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC1, 0x0a);             // read IRR by default
80103ff4:	6a 0a                	push   $0xa
80103ff6:	6a 20                	push   $0x20
80103ff8:	e8 ca fe ff ff       	call   80103ec7 <outb>
80103ffd:	83 c4 08             	add    $0x8,%esp

  outb(IO_PIC2, 0x68);             // OCW3
80104000:	6a 68                	push   $0x68
80104002:	68 a0 00 00 00       	push   $0xa0
80104007:	e8 bb fe ff ff       	call   80103ec7 <outb>
8010400c:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2, 0x0a);             // OCW3
8010400f:	6a 0a                	push   $0xa
80104011:	68 a0 00 00 00       	push   $0xa0
80104016:	e8 ac fe ff ff       	call   80103ec7 <outb>
8010401b:	83 c4 08             	add    $0x8,%esp

  if(irqmask != 0xFFFF)
8010401e:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80104025:	66 83 f8 ff          	cmp    $0xffff,%ax
80104029:	74 13                	je     8010403e <picinit+0xe6>
    picsetmask(irqmask);
8010402b:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80104032:	0f b7 c0             	movzwl %ax,%eax
80104035:	50                   	push   %eax
80104036:	e8 ab fe ff ff       	call   80103ee6 <picsetmask>
8010403b:	83 c4 04             	add    $0x4,%esp
}
8010403e:	90                   	nop
8010403f:	c9                   	leave  
80104040:	c3                   	ret    

80104041 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80104041:	55                   	push   %ebp
80104042:	89 e5                	mov    %esp,%ebp
80104044:	83 ec 18             	sub    $0x18,%esp
  struct pipe *p;

  p = 0;
80104047:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
8010404e:	8b 45 0c             	mov    0xc(%ebp),%eax
80104051:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104057:	8b 45 0c             	mov    0xc(%ebp),%eax
8010405a:	8b 10                	mov    (%eax),%edx
8010405c:	8b 45 08             	mov    0x8(%ebp),%eax
8010405f:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80104061:	e8 2d cf ff ff       	call   80100f93 <filealloc>
80104066:	89 c2                	mov    %eax,%edx
80104068:	8b 45 08             	mov    0x8(%ebp),%eax
8010406b:	89 10                	mov    %edx,(%eax)
8010406d:	8b 45 08             	mov    0x8(%ebp),%eax
80104070:	8b 00                	mov    (%eax),%eax
80104072:	85 c0                	test   %eax,%eax
80104074:	0f 84 cb 00 00 00    	je     80104145 <pipealloc+0x104>
8010407a:	e8 14 cf ff ff       	call   80100f93 <filealloc>
8010407f:	89 c2                	mov    %eax,%edx
80104081:	8b 45 0c             	mov    0xc(%ebp),%eax
80104084:	89 10                	mov    %edx,(%eax)
80104086:	8b 45 0c             	mov    0xc(%ebp),%eax
80104089:	8b 00                	mov    (%eax),%eax
8010408b:	85 c0                	test   %eax,%eax
8010408d:	0f 84 b2 00 00 00    	je     80104145 <pipealloc+0x104>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80104093:	e8 ce eb ff ff       	call   80102c66 <kalloc>
80104098:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010409b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010409f:	0f 84 9f 00 00 00    	je     80104144 <pipealloc+0x103>
    goto bad;
  p->readopen = 1;
801040a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040a8:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801040af:	00 00 00 
  p->writeopen = 1;
801040b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040b5:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801040bc:	00 00 00 
  p->nwrite = 0;
801040bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040c2:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801040c9:	00 00 00 
  p->nread = 0;
801040cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040cf:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801040d6:	00 00 00 
  initlock(&p->lock, "pipe");
801040d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040dc:	83 ec 08             	sub    $0x8,%esp
801040df:	68 b8 89 10 80       	push   $0x801089b8
801040e4:	50                   	push   %eax
801040e5:	e8 29 10 00 00       	call   80105113 <initlock>
801040ea:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801040ed:	8b 45 08             	mov    0x8(%ebp),%eax
801040f0:	8b 00                	mov    (%eax),%eax
801040f2:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801040f8:	8b 45 08             	mov    0x8(%ebp),%eax
801040fb:	8b 00                	mov    (%eax),%eax
801040fd:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80104101:	8b 45 08             	mov    0x8(%ebp),%eax
80104104:	8b 00                	mov    (%eax),%eax
80104106:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010410a:	8b 45 08             	mov    0x8(%ebp),%eax
8010410d:	8b 00                	mov    (%eax),%eax
8010410f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104112:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
80104115:	8b 45 0c             	mov    0xc(%ebp),%eax
80104118:	8b 00                	mov    (%eax),%eax
8010411a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80104120:	8b 45 0c             	mov    0xc(%ebp),%eax
80104123:	8b 00                	mov    (%eax),%eax
80104125:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80104129:	8b 45 0c             	mov    0xc(%ebp),%eax
8010412c:	8b 00                	mov    (%eax),%eax
8010412e:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80104132:	8b 45 0c             	mov    0xc(%ebp),%eax
80104135:	8b 00                	mov    (%eax),%eax
80104137:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010413a:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
8010413d:	b8 00 00 00 00       	mov    $0x0,%eax
80104142:	eb 4e                	jmp    80104192 <pipealloc+0x151>
    goto bad;
80104144:	90                   	nop

//PAGEBREAK: 20
 bad:
  if(p)
80104145:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104149:	74 0e                	je     80104159 <pipealloc+0x118>
    kfree((char*)p);
8010414b:	83 ec 0c             	sub    $0xc,%esp
8010414e:	ff 75 f4             	pushl  -0xc(%ebp)
80104151:	e8 73 ea ff ff       	call   80102bc9 <kfree>
80104156:	83 c4 10             	add    $0x10,%esp
  if(*f0)
80104159:	8b 45 08             	mov    0x8(%ebp),%eax
8010415c:	8b 00                	mov    (%eax),%eax
8010415e:	85 c0                	test   %eax,%eax
80104160:	74 11                	je     80104173 <pipealloc+0x132>
    fileclose(*f0);
80104162:	8b 45 08             	mov    0x8(%ebp),%eax
80104165:	8b 00                	mov    (%eax),%eax
80104167:	83 ec 0c             	sub    $0xc,%esp
8010416a:	50                   	push   %eax
8010416b:	e8 e1 ce ff ff       	call   80101051 <fileclose>
80104170:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80104173:	8b 45 0c             	mov    0xc(%ebp),%eax
80104176:	8b 00                	mov    (%eax),%eax
80104178:	85 c0                	test   %eax,%eax
8010417a:	74 11                	je     8010418d <pipealloc+0x14c>
    fileclose(*f1);
8010417c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010417f:	8b 00                	mov    (%eax),%eax
80104181:	83 ec 0c             	sub    $0xc,%esp
80104184:	50                   	push   %eax
80104185:	e8 c7 ce ff ff       	call   80101051 <fileclose>
8010418a:	83 c4 10             	add    $0x10,%esp
  return -1;
8010418d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104192:	c9                   	leave  
80104193:	c3                   	ret    

80104194 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80104194:	55                   	push   %ebp
80104195:	89 e5                	mov    %esp,%ebp
80104197:	83 ec 08             	sub    $0x8,%esp
  acquire(&p->lock);
8010419a:	8b 45 08             	mov    0x8(%ebp),%eax
8010419d:	83 ec 0c             	sub    $0xc,%esp
801041a0:	50                   	push   %eax
801041a1:	e8 8f 0f 00 00       	call   80105135 <acquire>
801041a6:	83 c4 10             	add    $0x10,%esp
  if(writable){
801041a9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801041ad:	74 23                	je     801041d2 <pipeclose+0x3e>
    p->writeopen = 0;
801041af:	8b 45 08             	mov    0x8(%ebp),%eax
801041b2:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
801041b9:	00 00 00 
    wakeup(&p->nread);
801041bc:	8b 45 08             	mov    0x8(%ebp),%eax
801041bf:	05 34 02 00 00       	add    $0x234,%eax
801041c4:	83 ec 0c             	sub    $0xc,%esp
801041c7:	50                   	push   %eax
801041c8:	e8 68 0d 00 00       	call   80104f35 <wakeup>
801041cd:	83 c4 10             	add    $0x10,%esp
801041d0:	eb 21                	jmp    801041f3 <pipeclose+0x5f>
  } else {
    p->readopen = 0;
801041d2:	8b 45 08             	mov    0x8(%ebp),%eax
801041d5:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
801041dc:	00 00 00 
    wakeup(&p->nwrite);
801041df:	8b 45 08             	mov    0x8(%ebp),%eax
801041e2:	05 38 02 00 00       	add    $0x238,%eax
801041e7:	83 ec 0c             	sub    $0xc,%esp
801041ea:	50                   	push   %eax
801041eb:	e8 45 0d 00 00       	call   80104f35 <wakeup>
801041f0:	83 c4 10             	add    $0x10,%esp
  }
  if(p->readopen == 0 && p->writeopen == 0){
801041f3:	8b 45 08             	mov    0x8(%ebp),%eax
801041f6:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
801041fc:	85 c0                	test   %eax,%eax
801041fe:	75 2c                	jne    8010422c <pipeclose+0x98>
80104200:	8b 45 08             	mov    0x8(%ebp),%eax
80104203:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80104209:	85 c0                	test   %eax,%eax
8010420b:	75 1f                	jne    8010422c <pipeclose+0x98>
    release(&p->lock);
8010420d:	8b 45 08             	mov    0x8(%ebp),%eax
80104210:	83 ec 0c             	sub    $0xc,%esp
80104213:	50                   	push   %eax
80104214:	e8 83 0f 00 00       	call   8010519c <release>
80104219:	83 c4 10             	add    $0x10,%esp
    kfree((char*)p);
8010421c:	83 ec 0c             	sub    $0xc,%esp
8010421f:	ff 75 08             	pushl  0x8(%ebp)
80104222:	e8 a2 e9 ff ff       	call   80102bc9 <kfree>
80104227:	83 c4 10             	add    $0x10,%esp
8010422a:	eb 0f                	jmp    8010423b <pipeclose+0xa7>
  } else
    release(&p->lock);
8010422c:	8b 45 08             	mov    0x8(%ebp),%eax
8010422f:	83 ec 0c             	sub    $0xc,%esp
80104232:	50                   	push   %eax
80104233:	e8 64 0f 00 00       	call   8010519c <release>
80104238:	83 c4 10             	add    $0x10,%esp
}
8010423b:	90                   	nop
8010423c:	c9                   	leave  
8010423d:	c3                   	ret    

8010423e <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
8010423e:	55                   	push   %ebp
8010423f:	89 e5                	mov    %esp,%ebp
80104241:	83 ec 18             	sub    $0x18,%esp
  int i;

  acquire(&p->lock);
80104244:	8b 45 08             	mov    0x8(%ebp),%eax
80104247:	83 ec 0c             	sub    $0xc,%esp
8010424a:	50                   	push   %eax
8010424b:	e8 e5 0e 00 00       	call   80105135 <acquire>
80104250:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++){
80104253:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010425a:	e9 ad 00 00 00       	jmp    8010430c <pipewrite+0xce>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
8010425f:	8b 45 08             	mov    0x8(%ebp),%eax
80104262:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80104268:	85 c0                	test   %eax,%eax
8010426a:	74 0d                	je     80104279 <pipewrite+0x3b>
8010426c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104272:	8b 40 24             	mov    0x24(%eax),%eax
80104275:	85 c0                	test   %eax,%eax
80104277:	74 19                	je     80104292 <pipewrite+0x54>
        release(&p->lock);
80104279:	8b 45 08             	mov    0x8(%ebp),%eax
8010427c:	83 ec 0c             	sub    $0xc,%esp
8010427f:	50                   	push   %eax
80104280:	e8 17 0f 00 00       	call   8010519c <release>
80104285:	83 c4 10             	add    $0x10,%esp
        return -1;
80104288:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010428d:	e9 a8 00 00 00       	jmp    8010433a <pipewrite+0xfc>
      }
      wakeup(&p->nread);
80104292:	8b 45 08             	mov    0x8(%ebp),%eax
80104295:	05 34 02 00 00       	add    $0x234,%eax
8010429a:	83 ec 0c             	sub    $0xc,%esp
8010429d:	50                   	push   %eax
8010429e:	e8 92 0c 00 00       	call   80104f35 <wakeup>
801042a3:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801042a6:	8b 45 08             	mov    0x8(%ebp),%eax
801042a9:	8b 55 08             	mov    0x8(%ebp),%edx
801042ac:	81 c2 38 02 00 00    	add    $0x238,%edx
801042b2:	83 ec 08             	sub    $0x8,%esp
801042b5:	50                   	push   %eax
801042b6:	52                   	push   %edx
801042b7:	e8 8e 0b 00 00       	call   80104e4a <sleep>
801042bc:	83 c4 10             	add    $0x10,%esp
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801042bf:	8b 45 08             	mov    0x8(%ebp),%eax
801042c2:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
801042c8:	8b 45 08             	mov    0x8(%ebp),%eax
801042cb:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
801042d1:	05 00 02 00 00       	add    $0x200,%eax
801042d6:	39 c2                	cmp    %eax,%edx
801042d8:	74 85                	je     8010425f <pipewrite+0x21>
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801042da:	8b 45 08             	mov    0x8(%ebp),%eax
801042dd:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801042e3:	8d 48 01             	lea    0x1(%eax),%ecx
801042e6:	8b 55 08             	mov    0x8(%ebp),%edx
801042e9:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
801042ef:	25 ff 01 00 00       	and    $0x1ff,%eax
801042f4:	89 c1                	mov    %eax,%ecx
801042f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801042f9:	8b 45 0c             	mov    0xc(%ebp),%eax
801042fc:	01 d0                	add    %edx,%eax
801042fe:	0f b6 10             	movzbl (%eax),%edx
80104301:	8b 45 08             	mov    0x8(%ebp),%eax
80104304:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
  for(i = 0; i < n; i++){
80104308:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010430c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010430f:	3b 45 10             	cmp    0x10(%ebp),%eax
80104312:	7c ab                	jl     801042bf <pipewrite+0x81>
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80104314:	8b 45 08             	mov    0x8(%ebp),%eax
80104317:	05 34 02 00 00       	add    $0x234,%eax
8010431c:	83 ec 0c             	sub    $0xc,%esp
8010431f:	50                   	push   %eax
80104320:	e8 10 0c 00 00       	call   80104f35 <wakeup>
80104325:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80104328:	8b 45 08             	mov    0x8(%ebp),%eax
8010432b:	83 ec 0c             	sub    $0xc,%esp
8010432e:	50                   	push   %eax
8010432f:	e8 68 0e 00 00       	call   8010519c <release>
80104334:	83 c4 10             	add    $0x10,%esp
  return n;
80104337:	8b 45 10             	mov    0x10(%ebp),%eax
}
8010433a:	c9                   	leave  
8010433b:	c3                   	ret    

8010433c <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
8010433c:	55                   	push   %ebp
8010433d:	89 e5                	mov    %esp,%ebp
8010433f:	53                   	push   %ebx
80104340:	83 ec 14             	sub    $0x14,%esp
  int i;

  acquire(&p->lock);
80104343:	8b 45 08             	mov    0x8(%ebp),%eax
80104346:	83 ec 0c             	sub    $0xc,%esp
80104349:	50                   	push   %eax
8010434a:	e8 e6 0d 00 00       	call   80105135 <acquire>
8010434f:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80104352:	eb 3f                	jmp    80104393 <piperead+0x57>
    if(proc->killed){
80104354:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010435a:	8b 40 24             	mov    0x24(%eax),%eax
8010435d:	85 c0                	test   %eax,%eax
8010435f:	74 19                	je     8010437a <piperead+0x3e>
      release(&p->lock);
80104361:	8b 45 08             	mov    0x8(%ebp),%eax
80104364:	83 ec 0c             	sub    $0xc,%esp
80104367:	50                   	push   %eax
80104368:	e8 2f 0e 00 00       	call   8010519c <release>
8010436d:	83 c4 10             	add    $0x10,%esp
      return -1;
80104370:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104375:	e9 bf 00 00 00       	jmp    80104439 <piperead+0xfd>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
8010437a:	8b 45 08             	mov    0x8(%ebp),%eax
8010437d:	8b 55 08             	mov    0x8(%ebp),%edx
80104380:	81 c2 34 02 00 00    	add    $0x234,%edx
80104386:	83 ec 08             	sub    $0x8,%esp
80104389:	50                   	push   %eax
8010438a:	52                   	push   %edx
8010438b:	e8 ba 0a 00 00       	call   80104e4a <sleep>
80104390:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80104393:	8b 45 08             	mov    0x8(%ebp),%eax
80104396:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
8010439c:	8b 45 08             	mov    0x8(%ebp),%eax
8010439f:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801043a5:	39 c2                	cmp    %eax,%edx
801043a7:	75 0d                	jne    801043b6 <piperead+0x7a>
801043a9:	8b 45 08             	mov    0x8(%ebp),%eax
801043ac:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
801043b2:	85 c0                	test   %eax,%eax
801043b4:	75 9e                	jne    80104354 <piperead+0x18>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801043b6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801043bd:	eb 49                	jmp    80104408 <piperead+0xcc>
    if(p->nread == p->nwrite)
801043bf:	8b 45 08             	mov    0x8(%ebp),%eax
801043c2:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
801043c8:	8b 45 08             	mov    0x8(%ebp),%eax
801043cb:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801043d1:	39 c2                	cmp    %eax,%edx
801043d3:	74 3d                	je     80104412 <piperead+0xd6>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
801043d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801043d8:	8b 45 0c             	mov    0xc(%ebp),%eax
801043db:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
801043de:	8b 45 08             	mov    0x8(%ebp),%eax
801043e1:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
801043e7:	8d 48 01             	lea    0x1(%eax),%ecx
801043ea:	8b 55 08             	mov    0x8(%ebp),%edx
801043ed:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
801043f3:	25 ff 01 00 00       	and    $0x1ff,%eax
801043f8:	89 c2                	mov    %eax,%edx
801043fa:	8b 45 08             	mov    0x8(%ebp),%eax
801043fd:	0f b6 44 10 34       	movzbl 0x34(%eax,%edx,1),%eax
80104402:	88 03                	mov    %al,(%ebx)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104404:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104408:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010440b:	3b 45 10             	cmp    0x10(%ebp),%eax
8010440e:	7c af                	jl     801043bf <piperead+0x83>
80104410:	eb 01                	jmp    80104413 <piperead+0xd7>
      break;
80104412:	90                   	nop
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80104413:	8b 45 08             	mov    0x8(%ebp),%eax
80104416:	05 38 02 00 00       	add    $0x238,%eax
8010441b:	83 ec 0c             	sub    $0xc,%esp
8010441e:	50                   	push   %eax
8010441f:	e8 11 0b 00 00       	call   80104f35 <wakeup>
80104424:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80104427:	8b 45 08             	mov    0x8(%ebp),%eax
8010442a:	83 ec 0c             	sub    $0xc,%esp
8010442d:	50                   	push   %eax
8010442e:	e8 69 0d 00 00       	call   8010519c <release>
80104433:	83 c4 10             	add    $0x10,%esp
  return i;
80104436:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104439:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010443c:	c9                   	leave  
8010443d:	c3                   	ret    

8010443e <readeflags>:
{
8010443e:	55                   	push   %ebp
8010443f:	89 e5                	mov    %esp,%ebp
80104441:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104444:	9c                   	pushf  
80104445:	58                   	pop    %eax
80104446:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80104449:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010444c:	c9                   	leave  
8010444d:	c3                   	ret    

8010444e <sti>:
{
8010444e:	55                   	push   %ebp
8010444f:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104451:	fb                   	sti    
}
80104452:	90                   	nop
80104453:	5d                   	pop    %ebp
80104454:	c3                   	ret    

80104455 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
80104455:	55                   	push   %ebp
80104456:	89 e5                	mov    %esp,%ebp
80104458:	83 ec 08             	sub    $0x8,%esp
  initlock(&ptable.lock, "ptable");
8010445b:	83 ec 08             	sub    $0x8,%esp
8010445e:	68 c0 89 10 80       	push   $0x801089c0
80104463:	68 60 29 11 80       	push   $0x80112960
80104468:	e8 a6 0c 00 00       	call   80105113 <initlock>
8010446d:	83 c4 10             	add    $0x10,%esp
}
80104470:	90                   	nop
80104471:	c9                   	leave  
80104472:	c3                   	ret    

80104473 <allocproc>:
// state required to run in the kernel.
// Otherwise return 0.
// Must hold ptable.lock.
static struct proc*
allocproc(void)
{
80104473:	55                   	push   %ebp
80104474:	89 e5                	mov    %esp,%ebp
80104476:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  char *sp;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104479:	c7 45 f4 94 29 11 80 	movl   $0x80112994,-0xc(%ebp)
80104480:	eb 0e                	jmp    80104490 <allocproc+0x1d>
    if(p->state == UNUSED)
80104482:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104485:	8b 40 0c             	mov    0xc(%eax),%eax
80104488:	85 c0                	test   %eax,%eax
8010448a:	74 17                	je     801044a3 <allocproc+0x30>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010448c:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
80104490:	81 7d f4 94 49 11 80 	cmpl   $0x80114994,-0xc(%ebp)
80104497:	72 e9                	jb     80104482 <allocproc+0xf>
      goto found;
  return 0;
80104499:	b8 00 00 00 00       	mov    $0x0,%eax
8010449e:	e9 a4 00 00 00       	jmp    80104547 <allocproc+0xd4>
      goto found;
801044a3:	90                   	nop

found:
  p->state = EMBRYO;
801044a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044a7:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
801044ae:	a1 04 b0 10 80       	mov    0x8010b004,%eax
801044b3:	8d 50 01             	lea    0x1(%eax),%edx
801044b6:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
801044bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801044bf:	89 42 10             	mov    %eax,0x10(%edx)

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801044c2:	e8 9f e7 ff ff       	call   80102c66 <kalloc>
801044c7:	89 c2                	mov    %eax,%edx
801044c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044cc:	89 50 08             	mov    %edx,0x8(%eax)
801044cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044d2:	8b 40 08             	mov    0x8(%eax),%eax
801044d5:	85 c0                	test   %eax,%eax
801044d7:	75 11                	jne    801044ea <allocproc+0x77>
    p->state = UNUSED;
801044d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044dc:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
801044e3:	b8 00 00 00 00       	mov    $0x0,%eax
801044e8:	eb 5d                	jmp    80104547 <allocproc+0xd4>
  }
  sp = p->kstack + KSTACKSIZE;
801044ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044ed:	8b 40 08             	mov    0x8(%eax),%eax
801044f0:	05 00 10 00 00       	add    $0x1000,%eax
801044f5:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801044f8:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
801044fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044ff:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104502:	89 50 18             	mov    %edx,0x18(%eax)

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
80104505:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
80104509:	ba 8d 67 10 80       	mov    $0x8010678d,%edx
8010450e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104511:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
80104513:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
80104517:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010451a:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010451d:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
80104520:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104523:	8b 40 1c             	mov    0x1c(%eax),%eax
80104526:	83 ec 04             	sub    $0x4,%esp
80104529:	6a 14                	push   $0x14
8010452b:	6a 00                	push   $0x0
8010452d:	50                   	push   %eax
8010452e:	e8 65 0e 00 00       	call   80105398 <memset>
80104533:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80104536:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104539:	8b 40 1c             	mov    0x1c(%eax),%eax
8010453c:	ba 04 4e 10 80       	mov    $0x80104e04,%edx
80104541:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
80104544:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104547:	c9                   	leave  
80104548:	c3                   	ret    

80104549 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80104549:	55                   	push   %ebp
8010454a:	89 e5                	mov    %esp,%ebp
8010454c:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  acquire(&ptable.lock);
8010454f:	83 ec 0c             	sub    $0xc,%esp
80104552:	68 60 29 11 80       	push   $0x80112960
80104557:	e8 d9 0b 00 00       	call   80105135 <acquire>
8010455c:	83 c4 10             	add    $0x10,%esp

  p = allocproc();
8010455f:	e8 0f ff ff ff       	call   80104473 <allocproc>
80104564:	89 45 f4             	mov    %eax,-0xc(%ebp)
  initproc = p;
80104567:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010456a:	a3 48 b6 10 80       	mov    %eax,0x8010b648
  if((p->pgdir = setupkvm()) == 0)
8010456f:	e8 de 38 00 00       	call   80107e52 <setupkvm>
80104574:	89 c2                	mov    %eax,%edx
80104576:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104579:	89 50 04             	mov    %edx,0x4(%eax)
8010457c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010457f:	8b 40 04             	mov    0x4(%eax),%eax
80104582:	85 c0                	test   %eax,%eax
80104584:	75 0d                	jne    80104593 <userinit+0x4a>
    panic("userinit: out of memory?");
80104586:	83 ec 0c             	sub    $0xc,%esp
80104589:	68 c7 89 10 80       	push   $0x801089c7
8010458e:	e8 d3 bf ff ff       	call   80100566 <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104593:	ba 2c 00 00 00       	mov    $0x2c,%edx
80104598:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010459b:	8b 40 04             	mov    0x4(%eax),%eax
8010459e:	83 ec 04             	sub    $0x4,%esp
801045a1:	52                   	push   %edx
801045a2:	68 e0 b4 10 80       	push   $0x8010b4e0
801045a7:	50                   	push   %eax
801045a8:	e8 ff 3a 00 00       	call   801080ac <inituvm>
801045ad:	83 c4 10             	add    $0x10,%esp
  p->sz = PGSIZE;
801045b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045b3:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
801045b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045bc:	8b 40 18             	mov    0x18(%eax),%eax
801045bf:	83 ec 04             	sub    $0x4,%esp
801045c2:	6a 4c                	push   $0x4c
801045c4:	6a 00                	push   $0x0
801045c6:	50                   	push   %eax
801045c7:	e8 cc 0d 00 00       	call   80105398 <memset>
801045cc:	83 c4 10             	add    $0x10,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801045cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045d2:	8b 40 18             	mov    0x18(%eax),%eax
801045d5:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801045db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045de:	8b 40 18             	mov    0x18(%eax),%eax
801045e1:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
801045e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045ea:	8b 40 18             	mov    0x18(%eax),%eax
801045ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
801045f0:	8b 52 18             	mov    0x18(%edx),%edx
801045f3:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
801045f7:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801045fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045fe:	8b 40 18             	mov    0x18(%eax),%eax
80104601:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104604:	8b 52 18             	mov    0x18(%edx),%edx
80104607:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
8010460b:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010460f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104612:	8b 40 18             	mov    0x18(%eax),%eax
80104615:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
8010461c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010461f:	8b 40 18             	mov    0x18(%eax),%eax
80104622:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80104629:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010462c:	8b 40 18             	mov    0x18(%eax),%eax
8010462f:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  p->tickets = TICKET_DEFAUT;// tickets do primeiro processo recebe 10 por padrão. global definida em proc.h
80104636:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104639:	c7 40 7c 0a 00 00 00 	movl   $0xa,0x7c(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
80104640:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104643:	83 c0 6c             	add    $0x6c,%eax
80104646:	83 ec 04             	sub    $0x4,%esp
80104649:	6a 10                	push   $0x10
8010464b:	68 e0 89 10 80       	push   $0x801089e0
80104650:	50                   	push   %eax
80104651:	e8 45 0f 00 00       	call   8010559b <safestrcpy>
80104656:	83 c4 10             	add    $0x10,%esp
  p->cwd = namei("/");
80104659:	83 ec 0c             	sub    $0xc,%esp
8010465c:	68 e9 89 10 80       	push   $0x801089e9
80104661:	e8 c2 de ff ff       	call   80102528 <namei>
80104666:	83 c4 10             	add    $0x10,%esp
80104669:	89 c2                	mov    %eax,%edx
8010466b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010466e:	89 50 68             	mov    %edx,0x68(%eax)

  p->state = RUNNABLE;
80104671:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104674:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

  release(&ptable.lock);
8010467b:	83 ec 0c             	sub    $0xc,%esp
8010467e:	68 60 29 11 80       	push   $0x80112960
80104683:	e8 14 0b 00 00       	call   8010519c <release>
80104688:	83 c4 10             	add    $0x10,%esp
}
8010468b:	90                   	nop
8010468c:	c9                   	leave  
8010468d:	c3                   	ret    

8010468e <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
8010468e:	55                   	push   %ebp
8010468f:	89 e5                	mov    %esp,%ebp
80104691:	83 ec 18             	sub    $0x18,%esp
  uint sz;

  sz = proc->sz;
80104694:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010469a:	8b 00                	mov    (%eax),%eax
8010469c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
8010469f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801046a3:	7e 31                	jle    801046d6 <growproc+0x48>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
801046a5:	8b 55 08             	mov    0x8(%ebp),%edx
801046a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046ab:	01 c2                	add    %eax,%edx
801046ad:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046b3:	8b 40 04             	mov    0x4(%eax),%eax
801046b6:	83 ec 04             	sub    $0x4,%esp
801046b9:	52                   	push   %edx
801046ba:	ff 75 f4             	pushl  -0xc(%ebp)
801046bd:	50                   	push   %eax
801046be:	e8 36 3b 00 00       	call   801081f9 <allocuvm>
801046c3:	83 c4 10             	add    $0x10,%esp
801046c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
801046c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801046cd:	75 3e                	jne    8010470d <growproc+0x7f>
      return -1;
801046cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046d4:	eb 59                	jmp    8010472f <growproc+0xa1>
  } else if(n < 0){
801046d6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801046da:	79 31                	jns    8010470d <growproc+0x7f>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
801046dc:	8b 55 08             	mov    0x8(%ebp),%edx
801046df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046e2:	01 c2                	add    %eax,%edx
801046e4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046ea:	8b 40 04             	mov    0x4(%eax),%eax
801046ed:	83 ec 04             	sub    $0x4,%esp
801046f0:	52                   	push   %edx
801046f1:	ff 75 f4             	pushl  -0xc(%ebp)
801046f4:	50                   	push   %eax
801046f5:	e8 c8 3b 00 00       	call   801082c2 <deallocuvm>
801046fa:	83 c4 10             	add    $0x10,%esp
801046fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104700:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104704:	75 07                	jne    8010470d <growproc+0x7f>
      return -1;
80104706:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010470b:	eb 22                	jmp    8010472f <growproc+0xa1>
  }
  proc->sz = sz;
8010470d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104713:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104716:	89 10                	mov    %edx,(%eax)
  switchuvm(proc);
80104718:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010471e:	83 ec 0c             	sub    $0xc,%esp
80104721:	50                   	push   %eax
80104722:	e8 12 38 00 00       	call   80107f39 <switchuvm>
80104727:	83 c4 10             	add    $0x10,%esp
  return 0;
8010472a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010472f:	c9                   	leave  
80104730:	c3                   	ret    

80104731 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(int tickets)
{
80104731:	55                   	push   %ebp
80104732:	89 e5                	mov    %esp,%ebp
80104734:	57                   	push   %edi
80104735:	56                   	push   %esi
80104736:	53                   	push   %ebx
80104737:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;

  acquire(&ptable.lock);
8010473a:	83 ec 0c             	sub    $0xc,%esp
8010473d:	68 60 29 11 80       	push   $0x80112960
80104742:	e8 ee 09 00 00       	call   80105135 <acquire>
80104747:	83 c4 10             	add    $0x10,%esp

  // Allocate process.
  if((np = allocproc()) == 0){
8010474a:	e8 24 fd ff ff       	call   80104473 <allocproc>
8010474f:	89 45 e0             	mov    %eax,-0x20(%ebp)
80104752:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80104756:	75 1a                	jne    80104772 <fork+0x41>
    release(&ptable.lock);
80104758:	83 ec 0c             	sub    $0xc,%esp
8010475b:	68 60 29 11 80       	push   $0x80112960
80104760:	e8 37 0a 00 00       	call   8010519c <release>
80104765:	83 c4 10             	add    $0x10,%esp
    return -1;
80104768:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010476d:	e9 cb 01 00 00       	jmp    8010493d <fork+0x20c>
  }

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
80104772:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104778:	8b 10                	mov    (%eax),%edx
8010477a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104780:	8b 40 04             	mov    0x4(%eax),%eax
80104783:	83 ec 08             	sub    $0x8,%esp
80104786:	52                   	push   %edx
80104787:	50                   	push   %eax
80104788:	e8 d3 3c 00 00       	call   80108460 <copyuvm>
8010478d:	83 c4 10             	add    $0x10,%esp
80104790:	89 c2                	mov    %eax,%edx
80104792:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104795:	89 50 04             	mov    %edx,0x4(%eax)
80104798:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010479b:	8b 40 04             	mov    0x4(%eax),%eax
8010479e:	85 c0                	test   %eax,%eax
801047a0:	75 40                	jne    801047e2 <fork+0xb1>
    kfree(np->kstack);
801047a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801047a5:	8b 40 08             	mov    0x8(%eax),%eax
801047a8:	83 ec 0c             	sub    $0xc,%esp
801047ab:	50                   	push   %eax
801047ac:	e8 18 e4 ff ff       	call   80102bc9 <kfree>
801047b1:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
801047b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801047b7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
801047be:	8b 45 e0             	mov    -0x20(%ebp),%eax
801047c1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    release(&ptable.lock);
801047c8:	83 ec 0c             	sub    $0xc,%esp
801047cb:	68 60 29 11 80       	push   $0x80112960
801047d0:	e8 c7 09 00 00       	call   8010519c <release>
801047d5:	83 c4 10             	add    $0x10,%esp
    return -1;
801047d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801047dd:	e9 5b 01 00 00       	jmp    8010493d <fork+0x20c>
  }
  np->sz = proc->sz;
801047e2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047e8:	8b 10                	mov    (%eax),%edx
801047ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
801047ed:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
801047ef:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801047f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801047f9:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
801047fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
801047ff:	8b 50 18             	mov    0x18(%eax),%edx
80104802:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104808:	8b 40 18             	mov    0x18(%eax),%eax
8010480b:	89 c3                	mov    %eax,%ebx
8010480d:	b8 13 00 00 00       	mov    $0x13,%eax
80104812:	89 d7                	mov    %edx,%edi
80104814:	89 de                	mov    %ebx,%esi
80104816:	89 c1                	mov    %eax,%ecx
80104818:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  ///////////////////////DEFINIÇÃO DA QUANTIDADE DE TICKETS DE CADA PROCESSO///////////////////////////////////////////
   if(tickets == 0){
8010481a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010481e:	75 0c                	jne    8010482c <fork+0xfb>
     np->tickets = TICKET_DEFAUT;
80104820:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104823:	c7 40 7c 0a 00 00 00 	movl   $0xa,0x7c(%eax)
8010482a:	eb 33                	jmp    8010485f <fork+0x12e>
   }
   else if(tickets < 0 || tickets < TICKET_MIN){
8010482c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104830:	78 06                	js     80104838 <fork+0x107>
80104832:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104836:	7f 0c                	jg     80104844 <fork+0x113>
     np->tickets = TICKET_MIN;
80104838:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010483b:	c7 40 7c 01 00 00 00 	movl   $0x1,0x7c(%eax)
80104842:	eb 1b                	jmp    8010485f <fork+0x12e>
   }
   else if(tickets > TICKET_MAX){
80104844:	83 7d 08 64          	cmpl   $0x64,0x8(%ebp)
80104848:	7e 0c                	jle    80104856 <fork+0x125>
     np->tickets = TICKET_MAX;
8010484a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010484d:	c7 40 7c 64 00 00 00 	movl   $0x64,0x7c(%eax)
80104854:	eb 09                	jmp    8010485f <fork+0x12e>
   }
   else{
     np->tickets = tickets;
80104856:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104859:	8b 55 08             	mov    0x8(%ebp),%edx
8010485c:	89 50 7c             	mov    %edx,0x7c(%eax)
   }

   cprintf("O processo %d foi criado com o valor de tickets: %d\n", np->pid, np->tickets);
8010485f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104862:	8b 50 7c             	mov    0x7c(%eax),%edx
80104865:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104868:	8b 40 10             	mov    0x10(%eax),%eax
8010486b:	83 ec 04             	sub    $0x4,%esp
8010486e:	52                   	push   %edx
8010486f:	50                   	push   %eax
80104870:	68 ec 89 10 80       	push   $0x801089ec
80104875:	e8 4c bb ff ff       	call   801003c6 <cprintf>
8010487a:	83 c4 10             	add    $0x10,%esp

   /////aqui termina as alterações feitas na função fork//////////////////////////////////////////////////////////////

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
8010487d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104880:	8b 40 18             	mov    0x18(%eax),%eax
80104883:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
8010488a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80104891:	eb 43                	jmp    801048d6 <fork+0x1a5>
    if(proc->ofile[i])
80104893:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104899:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010489c:	83 c2 08             	add    $0x8,%edx
8010489f:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801048a3:	85 c0                	test   %eax,%eax
801048a5:	74 2b                	je     801048d2 <fork+0x1a1>
      np->ofile[i] = filedup(proc->ofile[i]);
801048a7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048ad:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801048b0:	83 c2 08             	add    $0x8,%edx
801048b3:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801048b7:	83 ec 0c             	sub    $0xc,%esp
801048ba:	50                   	push   %eax
801048bb:	e8 40 c7 ff ff       	call   80101000 <filedup>
801048c0:	83 c4 10             	add    $0x10,%esp
801048c3:	89 c1                	mov    %eax,%ecx
801048c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801048c8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801048cb:	83 c2 08             	add    $0x8,%edx
801048ce:	89 4c 90 08          	mov    %ecx,0x8(%eax,%edx,4)
  for(i = 0; i < NOFILE; i++)
801048d2:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801048d6:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
801048da:	7e b7                	jle    80104893 <fork+0x162>
  np->cwd = idup(proc->cwd);
801048dc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048e2:	8b 40 68             	mov    0x68(%eax),%eax
801048e5:	83 ec 0c             	sub    $0xc,%esp
801048e8:	50                   	push   %eax
801048e9:	e8 42 d0 ff ff       	call   80101930 <idup>
801048ee:	83 c4 10             	add    $0x10,%esp
801048f1:	89 c2                	mov    %eax,%edx
801048f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801048f6:	89 50 68             	mov    %edx,0x68(%eax)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
801048f9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048ff:	8d 50 6c             	lea    0x6c(%eax),%edx
80104902:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104905:	83 c0 6c             	add    $0x6c,%eax
80104908:	83 ec 04             	sub    $0x4,%esp
8010490b:	6a 10                	push   $0x10
8010490d:	52                   	push   %edx
8010490e:	50                   	push   %eax
8010490f:	e8 87 0c 00 00       	call   8010559b <safestrcpy>
80104914:	83 c4 10             	add    $0x10,%esp

  pid = np->pid;
80104917:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010491a:	8b 40 10             	mov    0x10(%eax),%eax
8010491d:	89 45 dc             	mov    %eax,-0x24(%ebp)

  np->state = RUNNABLE;
80104920:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104923:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

  release(&ptable.lock);
8010492a:	83 ec 0c             	sub    $0xc,%esp
8010492d:	68 60 29 11 80       	push   $0x80112960
80104932:	e8 65 08 00 00       	call   8010519c <release>
80104937:	83 c4 10             	add    $0x10,%esp

  return pid;
8010493a:	8b 45 dc             	mov    -0x24(%ebp),%eax

}
8010493d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104940:	5b                   	pop    %ebx
80104941:	5e                   	pop    %esi
80104942:	5f                   	pop    %edi
80104943:	5d                   	pop    %ebp
80104944:	c3                   	ret    

80104945 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80104945:	55                   	push   %ebp
80104946:	89 e5                	mov    %esp,%ebp
80104948:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int fd;

  if(proc == initproc)
8010494b:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104952:	a1 48 b6 10 80       	mov    0x8010b648,%eax
80104957:	39 c2                	cmp    %eax,%edx
80104959:	75 0d                	jne    80104968 <exit+0x23>
    panic("init exiting");
8010495b:	83 ec 0c             	sub    $0xc,%esp
8010495e:	68 21 8a 10 80       	push   $0x80108a21
80104963:	e8 fe bb ff ff       	call   80100566 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104968:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
8010496f:	eb 48                	jmp    801049b9 <exit+0x74>
    if(proc->ofile[fd]){
80104971:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104977:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010497a:	83 c2 08             	add    $0x8,%edx
8010497d:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104981:	85 c0                	test   %eax,%eax
80104983:	74 30                	je     801049b5 <exit+0x70>
      fileclose(proc->ofile[fd]);
80104985:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010498b:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010498e:	83 c2 08             	add    $0x8,%edx
80104991:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104995:	83 ec 0c             	sub    $0xc,%esp
80104998:	50                   	push   %eax
80104999:	e8 b3 c6 ff ff       	call   80101051 <fileclose>
8010499e:	83 c4 10             	add    $0x10,%esp
      proc->ofile[fd] = 0;
801049a1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049a7:	8b 55 f0             	mov    -0x10(%ebp),%edx
801049aa:	83 c2 08             	add    $0x8,%edx
801049ad:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801049b4:	00 
  for(fd = 0; fd < NOFILE; fd++){
801049b5:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801049b9:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
801049bd:	7e b2                	jle    80104971 <exit+0x2c>
    }
  }

  begin_op();
801049bf:	e8 89 eb ff ff       	call   8010354d <begin_op>
  iput(proc->cwd);
801049c4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049ca:	8b 40 68             	mov    0x68(%eax),%eax
801049cd:	83 ec 0c             	sub    $0xc,%esp
801049d0:	50                   	push   %eax
801049d1:	e8 64 d1 ff ff       	call   80101b3a <iput>
801049d6:	83 c4 10             	add    $0x10,%esp
  end_op();
801049d9:	e8 fb eb ff ff       	call   801035d9 <end_op>
  proc->cwd = 0;
801049de:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049e4:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
801049eb:	83 ec 0c             	sub    $0xc,%esp
801049ee:	68 60 29 11 80       	push   $0x80112960
801049f3:	e8 3d 07 00 00       	call   80105135 <acquire>
801049f8:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
801049fb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a01:	8b 40 14             	mov    0x14(%eax),%eax
80104a04:	83 ec 0c             	sub    $0xc,%esp
80104a07:	50                   	push   %eax
80104a08:	e8 e9 04 00 00       	call   80104ef6 <wakeup1>
80104a0d:	83 c4 10             	add    $0x10,%esp

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a10:	c7 45 f4 94 29 11 80 	movl   $0x80112994,-0xc(%ebp)
80104a17:	eb 3c                	jmp    80104a55 <exit+0x110>
    if(p->parent == proc){
80104a19:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a1c:	8b 50 14             	mov    0x14(%eax),%edx
80104a1f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a25:	39 c2                	cmp    %eax,%edx
80104a27:	75 28                	jne    80104a51 <exit+0x10c>
      p->parent = initproc;
80104a29:	8b 15 48 b6 10 80    	mov    0x8010b648,%edx
80104a2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a32:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
80104a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a38:	8b 40 0c             	mov    0xc(%eax),%eax
80104a3b:	83 f8 05             	cmp    $0x5,%eax
80104a3e:	75 11                	jne    80104a51 <exit+0x10c>
        wakeup1(initproc);
80104a40:	a1 48 b6 10 80       	mov    0x8010b648,%eax
80104a45:	83 ec 0c             	sub    $0xc,%esp
80104a48:	50                   	push   %eax
80104a49:	e8 a8 04 00 00       	call   80104ef6 <wakeup1>
80104a4e:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a51:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
80104a55:	81 7d f4 94 49 11 80 	cmpl   $0x80114994,-0xc(%ebp)
80104a5c:	72 bb                	jb     80104a19 <exit+0xd4>
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
80104a5e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a64:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
80104a6b:	e8 9d 02 00 00       	call   80104d0d <sched>
  panic("zombie exit");
80104a70:	83 ec 0c             	sub    $0xc,%esp
80104a73:	68 2e 8a 10 80       	push   $0x80108a2e
80104a78:	e8 e9 ba ff ff       	call   80100566 <panic>

80104a7d <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80104a7d:	55                   	push   %ebp
80104a7e:	89 e5                	mov    %esp,%ebp
80104a80:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
80104a83:	83 ec 0c             	sub    $0xc,%esp
80104a86:	68 60 29 11 80       	push   $0x80112960
80104a8b:	e8 a5 06 00 00       	call   80105135 <acquire>
80104a90:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
80104a93:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a9a:	c7 45 f4 94 29 11 80 	movl   $0x80112994,-0xc(%ebp)
80104aa1:	e9 a6 00 00 00       	jmp    80104b4c <wait+0xcf>
      if(p->parent != proc)
80104aa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104aa9:	8b 50 14             	mov    0x14(%eax),%edx
80104aac:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ab2:	39 c2                	cmp    %eax,%edx
80104ab4:	0f 85 8d 00 00 00    	jne    80104b47 <wait+0xca>
        continue;
      havekids = 1;
80104aba:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
80104ac1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ac4:	8b 40 0c             	mov    0xc(%eax),%eax
80104ac7:	83 f8 05             	cmp    $0x5,%eax
80104aca:	75 7c                	jne    80104b48 <wait+0xcb>
        // Found one.
        pid = p->pid;
80104acc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104acf:	8b 40 10             	mov    0x10(%eax),%eax
80104ad2:	89 45 ec             	mov    %eax,-0x14(%ebp)
        kfree(p->kstack);
80104ad5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ad8:	8b 40 08             	mov    0x8(%eax),%eax
80104adb:	83 ec 0c             	sub    $0xc,%esp
80104ade:	50                   	push   %eax
80104adf:	e8 e5 e0 ff ff       	call   80102bc9 <kfree>
80104ae4:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
80104ae7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104aea:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
80104af1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104af4:	8b 40 04             	mov    0x4(%eax),%eax
80104af7:	83 ec 0c             	sub    $0xc,%esp
80104afa:	50                   	push   %eax
80104afb:	e8 7f 38 00 00       	call   8010837f <freevm>
80104b00:	83 c4 10             	add    $0x10,%esp
        p->pid = 0;
80104b03:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b06:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
80104b0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b10:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80104b17:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b1a:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
80104b1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b21:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        p->state = UNUSED;
80104b28:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b2b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        release(&ptable.lock);
80104b32:	83 ec 0c             	sub    $0xc,%esp
80104b35:	68 60 29 11 80       	push   $0x80112960
80104b3a:	e8 5d 06 00 00       	call   8010519c <release>
80104b3f:	83 c4 10             	add    $0x10,%esp
        return pid;
80104b42:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104b45:	eb 58                	jmp    80104b9f <wait+0x122>
        continue;
80104b47:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b48:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
80104b4c:	81 7d f4 94 49 11 80 	cmpl   $0x80114994,-0xc(%ebp)
80104b53:	0f 82 4d ff ff ff    	jb     80104aa6 <wait+0x29>
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80104b59:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104b5d:	74 0d                	je     80104b6c <wait+0xef>
80104b5f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b65:	8b 40 24             	mov    0x24(%eax),%eax
80104b68:	85 c0                	test   %eax,%eax
80104b6a:	74 17                	je     80104b83 <wait+0x106>
      release(&ptable.lock);
80104b6c:	83 ec 0c             	sub    $0xc,%esp
80104b6f:	68 60 29 11 80       	push   $0x80112960
80104b74:	e8 23 06 00 00       	call   8010519c <release>
80104b79:	83 c4 10             	add    $0x10,%esp
      return -1;
80104b7c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b81:	eb 1c                	jmp    80104b9f <wait+0x122>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80104b83:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b89:	83 ec 08             	sub    $0x8,%esp
80104b8c:	68 60 29 11 80       	push   $0x80112960
80104b91:	50                   	push   %eax
80104b92:	e8 b3 02 00 00       	call   80104e4a <sleep>
80104b97:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80104b9a:	e9 f4 fe ff ff       	jmp    80104a93 <wait+0x16>
  }
}
80104b9f:	c9                   	leave  
80104ba0:	c3                   	ret    

80104ba1 <rand>:
//////////////////////////////////////////////////////////////////////////////////////////////////
//Função para gerar numero randomico
//Função encontrada no próprio xv6 em usertests.c

unsigned long randstate = 1;
unsigned int rand(int TICKET_TOTAL){//////////////função rand
80104ba1:	55                   	push   %ebp
80104ba2:	89 e5                	mov    %esp,%ebp
  randstate = (randstate * 1664525 + 1013904223)%TICKET_TOTAL;
80104ba4:	a1 08 b0 10 80       	mov    0x8010b008,%eax
80104ba9:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
80104baf:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
80104bb4:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104bb7:	ba 00 00 00 00       	mov    $0x0,%edx
80104bbc:	f7 f1                	div    %ecx
80104bbe:	89 d0                	mov    %edx,%eax
80104bc0:	a3 08 b0 10 80       	mov    %eax,0x8010b008
  return randstate;
80104bc5:	a1 08 b0 10 80       	mov    0x8010b008,%eax
}
80104bca:	5d                   	pop    %ebp
80104bcb:	c3                   	ret    

80104bcc <ticketcount>:
/////////////////////////////////////////////////////////////////////////////////////////////////
//Função contador para contar o numero total de tickets que vão participar do sorteio
/////////////////////////////////////////////////////////////////////////////////////

int ticketcount(void) {
80104bcc:	55                   	push   %ebp
80104bcd:	89 e5                	mov    %esp,%ebp
80104bcf:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  int TICKET_TOTAL = 0;
80104bd2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104bd9:	c7 45 fc 94 29 11 80 	movl   $0x80112994,-0x4(%ebp)
80104be0:	eb 18                	jmp    80104bfa <ticketcount+0x2e>
    if (p->state == RUNNABLE) { //VERIFICA SE O PROCESSO É RUNNABLE
80104be2:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104be5:	8b 40 0c             	mov    0xc(%eax),%eax
80104be8:	83 f8 03             	cmp    $0x3,%eax
80104beb:	75 09                	jne    80104bf6 <ticketcount+0x2a>
      TICKET_TOTAL += p->tickets; //SOMA TODOS OS TICKETS EM TICKET_COUNT
80104bed:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104bf0:	8b 40 7c             	mov    0x7c(%eax),%eax
80104bf3:	01 45 f8             	add    %eax,-0x8(%ebp)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104bf6:	83 6d fc 80          	subl   $0xffffff80,-0x4(%ebp)
80104bfa:	81 7d fc 94 49 11 80 	cmpl   $0x80114994,-0x4(%ebp)
80104c01:	72 df                	jb     80104be2 <ticketcount+0x16>
    }
  }
  return TICKET_TOTAL; //RETORNA O VALOR FINAL
80104c03:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80104c06:	c9                   	leave  
80104c07:	c3                   	ret    

80104c08 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80104c08:	55                   	push   %ebp
80104c09:	89 e5                	mov    %esp,%ebp
80104c0b:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int vencedor=0;//variavel que recerá o número aleatório da função rand
80104c0e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  int numtickets;//variavel que recerá o número de tickets da função ticketcount

  for(;;){

    // Enable interrupts on this processor.
    sti();
80104c15:	e8 34 f8 ff ff       	call   8010444e <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80104c1a:	83 ec 0c             	sub    $0xc,%esp
80104c1d:	68 60 29 11 80       	push   $0x80112960
80104c22:	e8 0e 05 00 00       	call   80105135 <acquire>
80104c27:	83 c4 10             	add    $0x10,%esp


/////////////////////////////////////////////////////////////////////////////////////////////
  numtickets = ticketcount();//passa o numero de tickets do sorteio para o escalonador
80104c2a:	e8 9d ff ff ff       	call   80104bcc <ticketcount>
80104c2f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(numtickets > 0){
80104c32:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80104c36:	0f 8e bc 00 00 00    	jle    80104cf8 <scheduler+0xf0>
    vencedor = rand(numtickets);//chama a função rand usando o número de tickets RUNNABLE como semente
80104c3c:	83 ec 0c             	sub    $0xc,%esp
80104c3f:	ff 75 ec             	pushl  -0x14(%ebp)
80104c42:	e8 5a ff ff ff       	call   80104ba1 <rand>
80104c47:	83 c4 10             	add    $0x10,%esp
80104c4a:	89 45 f0             	mov    %eax,-0x10(%ebp)

    if(vencedor < 0){//re o rand retornar negativo, multiplica por -1
80104c4d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104c51:	79 03                	jns    80104c56 <scheduler+0x4e>
      vencedor = vencedor * -1;
80104c53:	f7 5d f0             	negl   -0x10(%ebp)
    }
    if(numtickets < vencedor){//se o numero do sorteado for maior que o numero de tickets, feito outra operação para diminuir o valor
80104c56:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104c59:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80104c5c:	7d 0a                	jge    80104c68 <scheduler+0x60>
      vencedor = vencedor % numtickets;
80104c5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c61:	99                   	cltd   
80104c62:	f7 7d ec             	idivl  -0x14(%ebp)
80104c65:	89 55 f0             	mov    %edx,-0x10(%ebp)
    }
//escalonador
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){//semelhante ao original
80104c68:	c7 45 f4 94 29 11 80 	movl   $0x80112994,-0xc(%ebp)
80104c6f:	eb 7a                	jmp    80104ceb <scheduler+0xe3>
        if (p->state == RUNNABLE) {//verifica se o processo é runnable
80104c71:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c74:	8b 40 0c             	mov    0xc(%eax),%eax
80104c77:	83 f8 03             	cmp    $0x3,%eax
80104c7a:	75 09                	jne    80104c85 <scheduler+0x7d>
          vencedor = vencedor - p->tickets;// se encoutrou um processo, então desconta o valor de tickets do mesmo
80104c7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c7f:	8b 40 7c             	mov    0x7c(%eax),%eax
80104c82:	29 45 f0             	sub    %eax,-0x10(%ebp)
        }
        if(p->state != RUNNABLE || vencedor >= 0) {//encontra o ticket vencedor quando o valor de vencedor for 0 ou menor
80104c85:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c88:	8b 40 0c             	mov    0xc(%eax),%eax
80104c8b:	83 f8 03             	cmp    $0x3,%eax
80104c8e:	75 56                	jne    80104ce6 <scheduler+0xde>
80104c90:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104c94:	79 50                	jns    80104ce6 <scheduler+0xde>


// Switch to chosen process.  It is the process's job
// to release ptable.lock and then reacquire it
// before jumping back to us.
proc = p;
80104c96:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c99:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
switchuvm(p);
80104c9f:	83 ec 0c             	sub    $0xc,%esp
80104ca2:	ff 75 f4             	pushl  -0xc(%ebp)
80104ca5:	e8 8f 32 00 00       	call   80107f39 <switchuvm>
80104caa:	83 c4 10             	add    $0x10,%esp
p->state = RUNNING;
80104cad:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cb0:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
swtch(&cpu->scheduler, p->context);
80104cb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cba:	8b 40 1c             	mov    0x1c(%eax),%eax
80104cbd:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104cc4:	83 c2 04             	add    $0x4,%edx
80104cc7:	83 ec 08             	sub    $0x8,%esp
80104cca:	50                   	push   %eax
80104ccb:	52                   	push   %edx
80104ccc:	e8 3b 09 00 00       	call   8010560c <swtch>
80104cd1:	83 c4 10             	add    $0x10,%esp
switchkvm();
80104cd4:	e8 43 32 00 00       	call   80107f1c <switchkvm>

// Process is done running for now.
// It should have changed its p->state before coming back.
proc = 0;
80104cd9:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80104ce0:	00 00 00 00 
80104ce4:	eb 01                	jmp    80104ce7 <scheduler+0xdf>
          continue;
80104ce6:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){//semelhante ao original
80104ce7:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
80104ceb:	81 7d f4 94 49 11 80 	cmpl   $0x80114994,-0xc(%ebp)
80104cf2:	0f 82 79 ff ff ff    	jb     80104c71 <scheduler+0x69>
		}
	}
	release(&ptable.lock);
80104cf8:	83 ec 0c             	sub    $0xc,%esp
80104cfb:	68 60 29 11 80       	push   $0x80112960
80104d00:	e8 97 04 00 00       	call   8010519c <release>
80104d05:	83 c4 10             	add    $0x10,%esp
    sti();
80104d08:	e9 08 ff ff ff       	jmp    80104c15 <scheduler+0xd>

80104d0d <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80104d0d:	55                   	push   %ebp
80104d0e:	89 e5                	mov    %esp,%ebp
80104d10:	83 ec 18             	sub    $0x18,%esp
  int intena;

  if(!holding(&ptable.lock))
80104d13:	83 ec 0c             	sub    $0xc,%esp
80104d16:	68 60 29 11 80       	push   $0x80112960
80104d1b:	e8 48 05 00 00       	call   80105268 <holding>
80104d20:	83 c4 10             	add    $0x10,%esp
80104d23:	85 c0                	test   %eax,%eax
80104d25:	75 0d                	jne    80104d34 <sched+0x27>
    panic("sched ptable.lock");
80104d27:	83 ec 0c             	sub    $0xc,%esp
80104d2a:	68 3a 8a 10 80       	push   $0x80108a3a
80104d2f:	e8 32 b8 ff ff       	call   80100566 <panic>
  if(cpu->ncli != 1)
80104d34:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104d3a:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104d40:	83 f8 01             	cmp    $0x1,%eax
80104d43:	74 0d                	je     80104d52 <sched+0x45>
    panic("sched locks");
80104d45:	83 ec 0c             	sub    $0xc,%esp
80104d48:	68 4c 8a 10 80       	push   $0x80108a4c
80104d4d:	e8 14 b8 ff ff       	call   80100566 <panic>
  if(proc->state == RUNNING)
80104d52:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d58:	8b 40 0c             	mov    0xc(%eax),%eax
80104d5b:	83 f8 04             	cmp    $0x4,%eax
80104d5e:	75 0d                	jne    80104d6d <sched+0x60>
    panic("sched running");
80104d60:	83 ec 0c             	sub    $0xc,%esp
80104d63:	68 58 8a 10 80       	push   $0x80108a58
80104d68:	e8 f9 b7 ff ff       	call   80100566 <panic>
  if(readeflags()&FL_IF)
80104d6d:	e8 cc f6 ff ff       	call   8010443e <readeflags>
80104d72:	25 00 02 00 00       	and    $0x200,%eax
80104d77:	85 c0                	test   %eax,%eax
80104d79:	74 0d                	je     80104d88 <sched+0x7b>
    panic("sched interruptible");
80104d7b:	83 ec 0c             	sub    $0xc,%esp
80104d7e:	68 66 8a 10 80       	push   $0x80108a66
80104d83:	e8 de b7 ff ff       	call   80100566 <panic>
  intena = cpu->intena;
80104d88:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104d8e:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104d94:	89 45 f4             	mov    %eax,-0xc(%ebp)
  swtch(&proc->context, cpu->scheduler);
80104d97:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104d9d:	8b 40 04             	mov    0x4(%eax),%eax
80104da0:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104da7:	83 c2 1c             	add    $0x1c,%edx
80104daa:	83 ec 08             	sub    $0x8,%esp
80104dad:	50                   	push   %eax
80104dae:	52                   	push   %edx
80104daf:	e8 58 08 00 00       	call   8010560c <swtch>
80104db4:	83 c4 10             	add    $0x10,%esp
  cpu->intena = intena;
80104db7:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104dbd:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104dc0:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104dc6:	90                   	nop
80104dc7:	c9                   	leave  
80104dc8:	c3                   	ret    

80104dc9 <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104dc9:	55                   	push   %ebp
80104dca:	89 e5                	mov    %esp,%ebp
80104dcc:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104dcf:	83 ec 0c             	sub    $0xc,%esp
80104dd2:	68 60 29 11 80       	push   $0x80112960
80104dd7:	e8 59 03 00 00       	call   80105135 <acquire>
80104ddc:	83 c4 10             	add    $0x10,%esp
  proc->state = RUNNABLE;
80104ddf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104de5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80104dec:	e8 1c ff ff ff       	call   80104d0d <sched>
  release(&ptable.lock);
80104df1:	83 ec 0c             	sub    $0xc,%esp
80104df4:	68 60 29 11 80       	push   $0x80112960
80104df9:	e8 9e 03 00 00       	call   8010519c <release>
80104dfe:	83 c4 10             	add    $0x10,%esp
}
80104e01:	90                   	nop
80104e02:	c9                   	leave  
80104e03:	c3                   	ret    

80104e04 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104e04:	55                   	push   %ebp
80104e05:	89 e5                	mov    %esp,%ebp
80104e07:	83 ec 08             	sub    $0x8,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104e0a:	83 ec 0c             	sub    $0xc,%esp
80104e0d:	68 60 29 11 80       	push   $0x80112960
80104e12:	e8 85 03 00 00       	call   8010519c <release>
80104e17:	83 c4 10             	add    $0x10,%esp

  if (first) {
80104e1a:	a1 0c b0 10 80       	mov    0x8010b00c,%eax
80104e1f:	85 c0                	test   %eax,%eax
80104e21:	74 24                	je     80104e47 <forkret+0x43>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
80104e23:	c7 05 0c b0 10 80 00 	movl   $0x0,0x8010b00c
80104e2a:	00 00 00 
    iinit(ROOTDEV);
80104e2d:	83 ec 0c             	sub    $0xc,%esp
80104e30:	6a 01                	push   $0x1
80104e32:	e8 07 c8 ff ff       	call   8010163e <iinit>
80104e37:	83 c4 10             	add    $0x10,%esp
    initlog(ROOTDEV);
80104e3a:	83 ec 0c             	sub    $0xc,%esp
80104e3d:	6a 01                	push   $0x1
80104e3f:	e8 eb e4 ff ff       	call   8010332f <initlog>
80104e44:	83 c4 10             	add    $0x10,%esp
  }

  // Return to "caller", actually trapret (see allocproc).
}
80104e47:	90                   	nop
80104e48:	c9                   	leave  
80104e49:	c3                   	ret    

80104e4a <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104e4a:	55                   	push   %ebp
80104e4b:	89 e5                	mov    %esp,%ebp
80104e4d:	83 ec 08             	sub    $0x8,%esp
  if(proc == 0)
80104e50:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e56:	85 c0                	test   %eax,%eax
80104e58:	75 0d                	jne    80104e67 <sleep+0x1d>
    panic("sleep");
80104e5a:	83 ec 0c             	sub    $0xc,%esp
80104e5d:	68 7a 8a 10 80       	push   $0x80108a7a
80104e62:	e8 ff b6 ff ff       	call   80100566 <panic>

  if(lk == 0)
80104e67:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104e6b:	75 0d                	jne    80104e7a <sleep+0x30>
    panic("sleep without lk");
80104e6d:	83 ec 0c             	sub    $0xc,%esp
80104e70:	68 80 8a 10 80       	push   $0x80108a80
80104e75:	e8 ec b6 ff ff       	call   80100566 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104e7a:	81 7d 0c 60 29 11 80 	cmpl   $0x80112960,0xc(%ebp)
80104e81:	74 1e                	je     80104ea1 <sleep+0x57>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104e83:	83 ec 0c             	sub    $0xc,%esp
80104e86:	68 60 29 11 80       	push   $0x80112960
80104e8b:	e8 a5 02 00 00       	call   80105135 <acquire>
80104e90:	83 c4 10             	add    $0x10,%esp
    release(lk);
80104e93:	83 ec 0c             	sub    $0xc,%esp
80104e96:	ff 75 0c             	pushl  0xc(%ebp)
80104e99:	e8 fe 02 00 00       	call   8010519c <release>
80104e9e:	83 c4 10             	add    $0x10,%esp
  }

  // Go to sleep.
  proc->chan = chan;
80104ea1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ea7:	8b 55 08             	mov    0x8(%ebp),%edx
80104eaa:	89 50 20             	mov    %edx,0x20(%eax)
  proc->state = SLEEPING;
80104ead:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104eb3:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80104eba:	e8 4e fe ff ff       	call   80104d0d <sched>

  // Tidy up.
  proc->chan = 0;
80104ebf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ec5:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104ecc:	81 7d 0c 60 29 11 80 	cmpl   $0x80112960,0xc(%ebp)
80104ed3:	74 1e                	je     80104ef3 <sleep+0xa9>
    release(&ptable.lock);
80104ed5:	83 ec 0c             	sub    $0xc,%esp
80104ed8:	68 60 29 11 80       	push   $0x80112960
80104edd:	e8 ba 02 00 00       	call   8010519c <release>
80104ee2:	83 c4 10             	add    $0x10,%esp
    acquire(lk);
80104ee5:	83 ec 0c             	sub    $0xc,%esp
80104ee8:	ff 75 0c             	pushl  0xc(%ebp)
80104eeb:	e8 45 02 00 00       	call   80105135 <acquire>
80104ef0:	83 c4 10             	add    $0x10,%esp
  }
}
80104ef3:	90                   	nop
80104ef4:	c9                   	leave  
80104ef5:	c3                   	ret    

80104ef6 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80104ef6:	55                   	push   %ebp
80104ef7:	89 e5                	mov    %esp,%ebp
80104ef9:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104efc:	c7 45 fc 94 29 11 80 	movl   $0x80112994,-0x4(%ebp)
80104f03:	eb 24                	jmp    80104f29 <wakeup1+0x33>
    if(p->state == SLEEPING && p->chan == chan)
80104f05:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104f08:	8b 40 0c             	mov    0xc(%eax),%eax
80104f0b:	83 f8 02             	cmp    $0x2,%eax
80104f0e:	75 15                	jne    80104f25 <wakeup1+0x2f>
80104f10:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104f13:	8b 40 20             	mov    0x20(%eax),%eax
80104f16:	3b 45 08             	cmp    0x8(%ebp),%eax
80104f19:	75 0a                	jne    80104f25 <wakeup1+0x2f>
      p->state = RUNNABLE;
80104f1b:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104f1e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104f25:	83 6d fc 80          	subl   $0xffffff80,-0x4(%ebp)
80104f29:	81 7d fc 94 49 11 80 	cmpl   $0x80114994,-0x4(%ebp)
80104f30:	72 d3                	jb     80104f05 <wakeup1+0xf>
}
80104f32:	90                   	nop
80104f33:	c9                   	leave  
80104f34:	c3                   	ret    

80104f35 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104f35:	55                   	push   %ebp
80104f36:	89 e5                	mov    %esp,%ebp
80104f38:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);
80104f3b:	83 ec 0c             	sub    $0xc,%esp
80104f3e:	68 60 29 11 80       	push   $0x80112960
80104f43:	e8 ed 01 00 00       	call   80105135 <acquire>
80104f48:	83 c4 10             	add    $0x10,%esp
  wakeup1(chan);
80104f4b:	83 ec 0c             	sub    $0xc,%esp
80104f4e:	ff 75 08             	pushl  0x8(%ebp)
80104f51:	e8 a0 ff ff ff       	call   80104ef6 <wakeup1>
80104f56:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
80104f59:	83 ec 0c             	sub    $0xc,%esp
80104f5c:	68 60 29 11 80       	push   $0x80112960
80104f61:	e8 36 02 00 00       	call   8010519c <release>
80104f66:	83 c4 10             	add    $0x10,%esp
}
80104f69:	90                   	nop
80104f6a:	c9                   	leave  
80104f6b:	c3                   	ret    

80104f6c <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104f6c:	55                   	push   %ebp
80104f6d:	89 e5                	mov    %esp,%ebp
80104f6f:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  acquire(&ptable.lock);
80104f72:	83 ec 0c             	sub    $0xc,%esp
80104f75:	68 60 29 11 80       	push   $0x80112960
80104f7a:	e8 b6 01 00 00       	call   80105135 <acquire>
80104f7f:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104f82:	c7 45 f4 94 29 11 80 	movl   $0x80112994,-0xc(%ebp)
80104f89:	eb 45                	jmp    80104fd0 <kill+0x64>
    if(p->pid == pid){
80104f8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f8e:	8b 40 10             	mov    0x10(%eax),%eax
80104f91:	3b 45 08             	cmp    0x8(%ebp),%eax
80104f94:	75 36                	jne    80104fcc <kill+0x60>
      p->killed = 1;
80104f96:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f99:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104fa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fa3:	8b 40 0c             	mov    0xc(%eax),%eax
80104fa6:	83 f8 02             	cmp    $0x2,%eax
80104fa9:	75 0a                	jne    80104fb5 <kill+0x49>
        p->state = RUNNABLE;
80104fab:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fae:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104fb5:	83 ec 0c             	sub    $0xc,%esp
80104fb8:	68 60 29 11 80       	push   $0x80112960
80104fbd:	e8 da 01 00 00       	call   8010519c <release>
80104fc2:	83 c4 10             	add    $0x10,%esp
      return 0;
80104fc5:	b8 00 00 00 00       	mov    $0x0,%eax
80104fca:	eb 22                	jmp    80104fee <kill+0x82>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104fcc:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
80104fd0:	81 7d f4 94 49 11 80 	cmpl   $0x80114994,-0xc(%ebp)
80104fd7:	72 b2                	jb     80104f8b <kill+0x1f>
    }
  }
  release(&ptable.lock);
80104fd9:	83 ec 0c             	sub    $0xc,%esp
80104fdc:	68 60 29 11 80       	push   $0x80112960
80104fe1:	e8 b6 01 00 00       	call   8010519c <release>
80104fe6:	83 c4 10             	add    $0x10,%esp
  return -1;
80104fe9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104fee:	c9                   	leave  
80104fef:	c3                   	ret    

80104ff0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104ff0:	55                   	push   %ebp
80104ff1:	89 e5                	mov    %esp,%ebp
80104ff3:	83 ec 48             	sub    $0x48,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ff6:	c7 45 f0 94 29 11 80 	movl   $0x80112994,-0x10(%ebp)
80104ffd:	e9 c9 00 00 00       	jmp    801050cb <procdump+0xdb>
    if(p->state == UNUSED)
80105002:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105005:	8b 40 0c             	mov    0xc(%eax),%eax
80105008:	85 c0                	test   %eax,%eax
8010500a:	0f 84 b6 00 00 00    	je     801050c6 <procdump+0xd6>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80105010:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105013:	8b 40 0c             	mov    0xc(%eax),%eax
80105016:	83 f8 05             	cmp    $0x5,%eax
80105019:	77 23                	ja     8010503e <procdump+0x4e>
8010501b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010501e:	8b 40 0c             	mov    0xc(%eax),%eax
80105021:	8b 04 85 10 b0 10 80 	mov    -0x7fef4ff0(,%eax,4),%eax
80105028:	85 c0                	test   %eax,%eax
8010502a:	74 12                	je     8010503e <procdump+0x4e>
      state = states[p->state];
8010502c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010502f:	8b 40 0c             	mov    0xc(%eax),%eax
80105032:	8b 04 85 10 b0 10 80 	mov    -0x7fef4ff0(,%eax,4),%eax
80105039:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010503c:	eb 07                	jmp    80105045 <procdump+0x55>
    else
      state = "???";
8010503e:	c7 45 ec 91 8a 10 80 	movl   $0x80108a91,-0x14(%ebp)
    cprintf("%d %s %s tickets: %d", p->pid, state, p->name, p->tickets);
80105045:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105048:	8b 50 7c             	mov    0x7c(%eax),%edx
8010504b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010504e:	8d 48 6c             	lea    0x6c(%eax),%ecx
80105051:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105054:	8b 40 10             	mov    0x10(%eax),%eax
80105057:	83 ec 0c             	sub    $0xc,%esp
8010505a:	52                   	push   %edx
8010505b:	51                   	push   %ecx
8010505c:	ff 75 ec             	pushl  -0x14(%ebp)
8010505f:	50                   	push   %eax
80105060:	68 95 8a 10 80       	push   $0x80108a95
80105065:	e8 5c b3 ff ff       	call   801003c6 <cprintf>
8010506a:	83 c4 20             	add    $0x20,%esp
    if(p->state == SLEEPING){
8010506d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105070:	8b 40 0c             	mov    0xc(%eax),%eax
80105073:	83 f8 02             	cmp    $0x2,%eax
80105076:	75 3c                	jne    801050b4 <procdump+0xc4>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80105078:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010507b:	8b 40 1c             	mov    0x1c(%eax),%eax
8010507e:	8b 40 0c             	mov    0xc(%eax),%eax
80105081:	83 c0 08             	add    $0x8,%eax
80105084:	89 c2                	mov    %eax,%edx
80105086:	83 ec 08             	sub    $0x8,%esp
80105089:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010508c:	50                   	push   %eax
8010508d:	52                   	push   %edx
8010508e:	e8 5b 01 00 00       	call   801051ee <getcallerpcs>
80105093:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++){}
80105096:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010509d:	eb 04                	jmp    801050a3 <procdump+0xb3>
8010509f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801050a3:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801050a7:	7f 0b                	jg     801050b4 <procdump+0xc4>
801050a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050ac:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
801050b0:	85 c0                	test   %eax,%eax
801050b2:	75 eb                	jne    8010509f <procdump+0xaf>
        //cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801050b4:	83 ec 0c             	sub    $0xc,%esp
801050b7:	68 aa 8a 10 80       	push   $0x80108aaa
801050bc:	e8 05 b3 ff ff       	call   801003c6 <cprintf>
801050c1:	83 c4 10             	add    $0x10,%esp
801050c4:	eb 01                	jmp    801050c7 <procdump+0xd7>
      continue;
801050c6:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801050c7:	83 6d f0 80          	subl   $0xffffff80,-0x10(%ebp)
801050cb:	81 7d f0 94 49 11 80 	cmpl   $0x80114994,-0x10(%ebp)
801050d2:	0f 82 2a ff ff ff    	jb     80105002 <procdump+0x12>
  }
}
801050d8:	90                   	nop
801050d9:	c9                   	leave  
801050da:	c3                   	ret    

801050db <readeflags>:
{
801050db:	55                   	push   %ebp
801050dc:	89 e5                	mov    %esp,%ebp
801050de:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801050e1:	9c                   	pushf  
801050e2:	58                   	pop    %eax
801050e3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
801050e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801050e9:	c9                   	leave  
801050ea:	c3                   	ret    

801050eb <cli>:
{
801050eb:	55                   	push   %ebp
801050ec:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
801050ee:	fa                   	cli    
}
801050ef:	90                   	nop
801050f0:	5d                   	pop    %ebp
801050f1:	c3                   	ret    

801050f2 <sti>:
{
801050f2:	55                   	push   %ebp
801050f3:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
801050f5:	fb                   	sti    
}
801050f6:	90                   	nop
801050f7:	5d                   	pop    %ebp
801050f8:	c3                   	ret    

801050f9 <xchg>:
{
801050f9:	55                   	push   %ebp
801050fa:	89 e5                	mov    %esp,%ebp
801050fc:	83 ec 10             	sub    $0x10,%esp
  asm volatile("lock; xchgl %0, %1" :
801050ff:	8b 55 08             	mov    0x8(%ebp),%edx
80105102:	8b 45 0c             	mov    0xc(%ebp),%eax
80105105:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105108:	f0 87 02             	lock xchg %eax,(%edx)
8010510b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return result;
8010510e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105111:	c9                   	leave  
80105112:	c3                   	ret    

80105113 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80105113:	55                   	push   %ebp
80105114:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80105116:	8b 45 08             	mov    0x8(%ebp),%eax
80105119:	8b 55 0c             	mov    0xc(%ebp),%edx
8010511c:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
8010511f:	8b 45 08             	mov    0x8(%ebp),%eax
80105122:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80105128:	8b 45 08             	mov    0x8(%ebp),%eax
8010512b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80105132:	90                   	nop
80105133:	5d                   	pop    %ebp
80105134:	c3                   	ret    

80105135 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80105135:	55                   	push   %ebp
80105136:	89 e5                	mov    %esp,%ebp
80105138:	83 ec 08             	sub    $0x8,%esp
  pushcli(); // disable interrupts to avoid deadlock.
8010513b:	e8 52 01 00 00       	call   80105292 <pushcli>
  if(holding(lk))
80105140:	8b 45 08             	mov    0x8(%ebp),%eax
80105143:	83 ec 0c             	sub    $0xc,%esp
80105146:	50                   	push   %eax
80105147:	e8 1c 01 00 00       	call   80105268 <holding>
8010514c:	83 c4 10             	add    $0x10,%esp
8010514f:	85 c0                	test   %eax,%eax
80105151:	74 0d                	je     80105160 <acquire+0x2b>
    panic("acquire");
80105153:	83 ec 0c             	sub    $0xc,%esp
80105156:	68 d6 8a 10 80       	push   $0x80108ad6
8010515b:	e8 06 b4 ff ff       	call   80100566 <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
80105160:	90                   	nop
80105161:	8b 45 08             	mov    0x8(%ebp),%eax
80105164:	83 ec 08             	sub    $0x8,%esp
80105167:	6a 01                	push   $0x1
80105169:	50                   	push   %eax
8010516a:	e8 8a ff ff ff       	call   801050f9 <xchg>
8010516f:	83 c4 10             	add    $0x10,%esp
80105172:	85 c0                	test   %eax,%eax
80105174:	75 eb                	jne    80105161 <acquire+0x2c>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80105176:	8b 45 08             	mov    0x8(%ebp),%eax
80105179:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80105180:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
80105183:	8b 45 08             	mov    0x8(%ebp),%eax
80105186:	83 c0 0c             	add    $0xc,%eax
80105189:	83 ec 08             	sub    $0x8,%esp
8010518c:	50                   	push   %eax
8010518d:	8d 45 08             	lea    0x8(%ebp),%eax
80105190:	50                   	push   %eax
80105191:	e8 58 00 00 00       	call   801051ee <getcallerpcs>
80105196:	83 c4 10             	add    $0x10,%esp
}
80105199:	90                   	nop
8010519a:	c9                   	leave  
8010519b:	c3                   	ret    

8010519c <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
8010519c:	55                   	push   %ebp
8010519d:	89 e5                	mov    %esp,%ebp
8010519f:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
801051a2:	83 ec 0c             	sub    $0xc,%esp
801051a5:	ff 75 08             	pushl  0x8(%ebp)
801051a8:	e8 bb 00 00 00       	call   80105268 <holding>
801051ad:	83 c4 10             	add    $0x10,%esp
801051b0:	85 c0                	test   %eax,%eax
801051b2:	75 0d                	jne    801051c1 <release+0x25>
    panic("release");
801051b4:	83 ec 0c             	sub    $0xc,%esp
801051b7:	68 de 8a 10 80       	push   $0x80108ade
801051bc:	e8 a5 b3 ff ff       	call   80100566 <panic>

  lk->pcs[0] = 0;
801051c1:	8b 45 08             	mov    0x8(%ebp),%eax
801051c4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
801051cb:	8b 45 08             	mov    0x8(%ebp),%eax
801051ce:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
801051d5:	8b 45 08             	mov    0x8(%ebp),%eax
801051d8:	83 ec 08             	sub    $0x8,%esp
801051db:	6a 00                	push   $0x0
801051dd:	50                   	push   %eax
801051de:	e8 16 ff ff ff       	call   801050f9 <xchg>
801051e3:	83 c4 10             	add    $0x10,%esp

  popcli();
801051e6:	e8 ec 00 00 00       	call   801052d7 <popcli>
}
801051eb:	90                   	nop
801051ec:	c9                   	leave  
801051ed:	c3                   	ret    

801051ee <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801051ee:	55                   	push   %ebp
801051ef:	89 e5                	mov    %esp,%ebp
801051f1:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
801051f4:	8b 45 08             	mov    0x8(%ebp),%eax
801051f7:	83 e8 08             	sub    $0x8,%eax
801051fa:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
801051fd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80105204:	eb 38                	jmp    8010523e <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105206:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
8010520a:	74 53                	je     8010525f <getcallerpcs+0x71>
8010520c:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
80105213:	76 4a                	jbe    8010525f <getcallerpcs+0x71>
80105215:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
80105219:	74 44                	je     8010525f <getcallerpcs+0x71>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010521b:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010521e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80105225:	8b 45 0c             	mov    0xc(%ebp),%eax
80105228:	01 c2                	add    %eax,%edx
8010522a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010522d:	8b 40 04             	mov    0x4(%eax),%eax
80105230:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
80105232:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105235:	8b 00                	mov    (%eax),%eax
80105237:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
8010523a:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
8010523e:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80105242:	7e c2                	jle    80105206 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
80105244:	eb 19                	jmp    8010525f <getcallerpcs+0x71>
    pcs[i] = 0;
80105246:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105249:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80105250:	8b 45 0c             	mov    0xc(%ebp),%eax
80105253:	01 d0                	add    %edx,%eax
80105255:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
8010525b:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
8010525f:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80105263:	7e e1                	jle    80105246 <getcallerpcs+0x58>
}
80105265:	90                   	nop
80105266:	c9                   	leave  
80105267:	c3                   	ret    

80105268 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80105268:	55                   	push   %ebp
80105269:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
8010526b:	8b 45 08             	mov    0x8(%ebp),%eax
8010526e:	8b 00                	mov    (%eax),%eax
80105270:	85 c0                	test   %eax,%eax
80105272:	74 17                	je     8010528b <holding+0x23>
80105274:	8b 45 08             	mov    0x8(%ebp),%eax
80105277:	8b 50 08             	mov    0x8(%eax),%edx
8010527a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105280:	39 c2                	cmp    %eax,%edx
80105282:	75 07                	jne    8010528b <holding+0x23>
80105284:	b8 01 00 00 00       	mov    $0x1,%eax
80105289:	eb 05                	jmp    80105290 <holding+0x28>
8010528b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105290:	5d                   	pop    %ebp
80105291:	c3                   	ret    

80105292 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80105292:	55                   	push   %ebp
80105293:	89 e5                	mov    %esp,%ebp
80105295:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
80105298:	e8 3e fe ff ff       	call   801050db <readeflags>
8010529d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
801052a0:	e8 46 fe ff ff       	call   801050eb <cli>
  if(cpu->ncli++ == 0)
801052a5:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801052ac:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
801052b2:	8d 48 01             	lea    0x1(%eax),%ecx
801052b5:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
801052bb:	85 c0                	test   %eax,%eax
801052bd:	75 15                	jne    801052d4 <pushcli+0x42>
    cpu->intena = eflags & FL_IF;
801052bf:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801052c5:	8b 55 fc             	mov    -0x4(%ebp),%edx
801052c8:	81 e2 00 02 00 00    	and    $0x200,%edx
801052ce:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
801052d4:	90                   	nop
801052d5:	c9                   	leave  
801052d6:	c3                   	ret    

801052d7 <popcli>:

void
popcli(void)
{
801052d7:	55                   	push   %ebp
801052d8:	89 e5                	mov    %esp,%ebp
801052da:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
801052dd:	e8 f9 fd ff ff       	call   801050db <readeflags>
801052e2:	25 00 02 00 00       	and    $0x200,%eax
801052e7:	85 c0                	test   %eax,%eax
801052e9:	74 0d                	je     801052f8 <popcli+0x21>
    panic("popcli - interruptible");
801052eb:	83 ec 0c             	sub    $0xc,%esp
801052ee:	68 e6 8a 10 80       	push   $0x80108ae6
801052f3:	e8 6e b2 ff ff       	call   80100566 <panic>
  if(--cpu->ncli < 0)
801052f8:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801052fe:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80105304:	83 ea 01             	sub    $0x1,%edx
80105307:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
8010530d:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80105313:	85 c0                	test   %eax,%eax
80105315:	79 0d                	jns    80105324 <popcli+0x4d>
    panic("popcli");
80105317:	83 ec 0c             	sub    $0xc,%esp
8010531a:	68 fd 8a 10 80       	push   $0x80108afd
8010531f:	e8 42 b2 ff ff       	call   80100566 <panic>
  if(cpu->ncli == 0 && cpu->intena)
80105324:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010532a:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80105330:	85 c0                	test   %eax,%eax
80105332:	75 15                	jne    80105349 <popcli+0x72>
80105334:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010533a:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80105340:	85 c0                	test   %eax,%eax
80105342:	74 05                	je     80105349 <popcli+0x72>
    sti();
80105344:	e8 a9 fd ff ff       	call   801050f2 <sti>
}
80105349:	90                   	nop
8010534a:	c9                   	leave  
8010534b:	c3                   	ret    

8010534c <stosb>:
{
8010534c:	55                   	push   %ebp
8010534d:	89 e5                	mov    %esp,%ebp
8010534f:	57                   	push   %edi
80105350:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
80105351:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105354:	8b 55 10             	mov    0x10(%ebp),%edx
80105357:	8b 45 0c             	mov    0xc(%ebp),%eax
8010535a:	89 cb                	mov    %ecx,%ebx
8010535c:	89 df                	mov    %ebx,%edi
8010535e:	89 d1                	mov    %edx,%ecx
80105360:	fc                   	cld    
80105361:	f3 aa                	rep stos %al,%es:(%edi)
80105363:	89 ca                	mov    %ecx,%edx
80105365:	89 fb                	mov    %edi,%ebx
80105367:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010536a:	89 55 10             	mov    %edx,0x10(%ebp)
}
8010536d:	90                   	nop
8010536e:	5b                   	pop    %ebx
8010536f:	5f                   	pop    %edi
80105370:	5d                   	pop    %ebp
80105371:	c3                   	ret    

80105372 <stosl>:
{
80105372:	55                   	push   %ebp
80105373:	89 e5                	mov    %esp,%ebp
80105375:	57                   	push   %edi
80105376:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
80105377:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010537a:	8b 55 10             	mov    0x10(%ebp),%edx
8010537d:	8b 45 0c             	mov    0xc(%ebp),%eax
80105380:	89 cb                	mov    %ecx,%ebx
80105382:	89 df                	mov    %ebx,%edi
80105384:	89 d1                	mov    %edx,%ecx
80105386:	fc                   	cld    
80105387:	f3 ab                	rep stos %eax,%es:(%edi)
80105389:	89 ca                	mov    %ecx,%edx
8010538b:	89 fb                	mov    %edi,%ebx
8010538d:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105390:	89 55 10             	mov    %edx,0x10(%ebp)
}
80105393:	90                   	nop
80105394:	5b                   	pop    %ebx
80105395:	5f                   	pop    %edi
80105396:	5d                   	pop    %ebp
80105397:	c3                   	ret    

80105398 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105398:	55                   	push   %ebp
80105399:	89 e5                	mov    %esp,%ebp
  if ((int)dst%4 == 0 && n%4 == 0){
8010539b:	8b 45 08             	mov    0x8(%ebp),%eax
8010539e:	83 e0 03             	and    $0x3,%eax
801053a1:	85 c0                	test   %eax,%eax
801053a3:	75 43                	jne    801053e8 <memset+0x50>
801053a5:	8b 45 10             	mov    0x10(%ebp),%eax
801053a8:	83 e0 03             	and    $0x3,%eax
801053ab:	85 c0                	test   %eax,%eax
801053ad:	75 39                	jne    801053e8 <memset+0x50>
    c &= 0xFF;
801053af:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801053b6:	8b 45 10             	mov    0x10(%ebp),%eax
801053b9:	c1 e8 02             	shr    $0x2,%eax
801053bc:	89 c1                	mov    %eax,%ecx
801053be:	8b 45 0c             	mov    0xc(%ebp),%eax
801053c1:	c1 e0 18             	shl    $0x18,%eax
801053c4:	89 c2                	mov    %eax,%edx
801053c6:	8b 45 0c             	mov    0xc(%ebp),%eax
801053c9:	c1 e0 10             	shl    $0x10,%eax
801053cc:	09 c2                	or     %eax,%edx
801053ce:	8b 45 0c             	mov    0xc(%ebp),%eax
801053d1:	c1 e0 08             	shl    $0x8,%eax
801053d4:	09 d0                	or     %edx,%eax
801053d6:	0b 45 0c             	or     0xc(%ebp),%eax
801053d9:	51                   	push   %ecx
801053da:	50                   	push   %eax
801053db:	ff 75 08             	pushl  0x8(%ebp)
801053de:	e8 8f ff ff ff       	call   80105372 <stosl>
801053e3:	83 c4 0c             	add    $0xc,%esp
801053e6:	eb 12                	jmp    801053fa <memset+0x62>
  } else
    stosb(dst, c, n);
801053e8:	8b 45 10             	mov    0x10(%ebp),%eax
801053eb:	50                   	push   %eax
801053ec:	ff 75 0c             	pushl  0xc(%ebp)
801053ef:	ff 75 08             	pushl  0x8(%ebp)
801053f2:	e8 55 ff ff ff       	call   8010534c <stosb>
801053f7:	83 c4 0c             	add    $0xc,%esp
  return dst;
801053fa:	8b 45 08             	mov    0x8(%ebp),%eax
}
801053fd:	c9                   	leave  
801053fe:	c3                   	ret    

801053ff <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801053ff:	55                   	push   %ebp
80105400:	89 e5                	mov    %esp,%ebp
80105402:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
80105405:	8b 45 08             	mov    0x8(%ebp),%eax
80105408:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
8010540b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010540e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
80105411:	eb 30                	jmp    80105443 <memcmp+0x44>
    if(*s1 != *s2)
80105413:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105416:	0f b6 10             	movzbl (%eax),%edx
80105419:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010541c:	0f b6 00             	movzbl (%eax),%eax
8010541f:	38 c2                	cmp    %al,%dl
80105421:	74 18                	je     8010543b <memcmp+0x3c>
      return *s1 - *s2;
80105423:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105426:	0f b6 00             	movzbl (%eax),%eax
80105429:	0f b6 d0             	movzbl %al,%edx
8010542c:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010542f:	0f b6 00             	movzbl (%eax),%eax
80105432:	0f b6 c0             	movzbl %al,%eax
80105435:	29 c2                	sub    %eax,%edx
80105437:	89 d0                	mov    %edx,%eax
80105439:	eb 1a                	jmp    80105455 <memcmp+0x56>
    s1++, s2++;
8010543b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010543f:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  while(n-- > 0){
80105443:	8b 45 10             	mov    0x10(%ebp),%eax
80105446:	8d 50 ff             	lea    -0x1(%eax),%edx
80105449:	89 55 10             	mov    %edx,0x10(%ebp)
8010544c:	85 c0                	test   %eax,%eax
8010544e:	75 c3                	jne    80105413 <memcmp+0x14>
  }

  return 0;
80105450:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105455:	c9                   	leave  
80105456:	c3                   	ret    

80105457 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105457:	55                   	push   %ebp
80105458:	89 e5                	mov    %esp,%ebp
8010545a:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
8010545d:	8b 45 0c             	mov    0xc(%ebp),%eax
80105460:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
80105463:	8b 45 08             	mov    0x8(%ebp),%eax
80105466:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
80105469:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010546c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
8010546f:	73 54                	jae    801054c5 <memmove+0x6e>
80105471:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105474:	8b 45 10             	mov    0x10(%ebp),%eax
80105477:	01 d0                	add    %edx,%eax
80105479:	3b 45 f8             	cmp    -0x8(%ebp),%eax
8010547c:	76 47                	jbe    801054c5 <memmove+0x6e>
    s += n;
8010547e:	8b 45 10             	mov    0x10(%ebp),%eax
80105481:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
80105484:	8b 45 10             	mov    0x10(%ebp),%eax
80105487:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
8010548a:	eb 13                	jmp    8010549f <memmove+0x48>
      *--d = *--s;
8010548c:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
80105490:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
80105494:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105497:	0f b6 10             	movzbl (%eax),%edx
8010549a:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010549d:	88 10                	mov    %dl,(%eax)
    while(n-- > 0)
8010549f:	8b 45 10             	mov    0x10(%ebp),%eax
801054a2:	8d 50 ff             	lea    -0x1(%eax),%edx
801054a5:	89 55 10             	mov    %edx,0x10(%ebp)
801054a8:	85 c0                	test   %eax,%eax
801054aa:	75 e0                	jne    8010548c <memmove+0x35>
  if(s < d && s + n > d){
801054ac:	eb 24                	jmp    801054d2 <memmove+0x7b>
  } else
    while(n-- > 0)
      *d++ = *s++;
801054ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
801054b1:	8d 50 01             	lea    0x1(%eax),%edx
801054b4:	89 55 f8             	mov    %edx,-0x8(%ebp)
801054b7:	8b 55 fc             	mov    -0x4(%ebp),%edx
801054ba:	8d 4a 01             	lea    0x1(%edx),%ecx
801054bd:	89 4d fc             	mov    %ecx,-0x4(%ebp)
801054c0:	0f b6 12             	movzbl (%edx),%edx
801054c3:	88 10                	mov    %dl,(%eax)
    while(n-- > 0)
801054c5:	8b 45 10             	mov    0x10(%ebp),%eax
801054c8:	8d 50 ff             	lea    -0x1(%eax),%edx
801054cb:	89 55 10             	mov    %edx,0x10(%ebp)
801054ce:	85 c0                	test   %eax,%eax
801054d0:	75 dc                	jne    801054ae <memmove+0x57>

  return dst;
801054d2:	8b 45 08             	mov    0x8(%ebp),%eax
}
801054d5:	c9                   	leave  
801054d6:	c3                   	ret    

801054d7 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801054d7:	55                   	push   %ebp
801054d8:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
801054da:	ff 75 10             	pushl  0x10(%ebp)
801054dd:	ff 75 0c             	pushl  0xc(%ebp)
801054e0:	ff 75 08             	pushl  0x8(%ebp)
801054e3:	e8 6f ff ff ff       	call   80105457 <memmove>
801054e8:	83 c4 0c             	add    $0xc,%esp
}
801054eb:	c9                   	leave  
801054ec:	c3                   	ret    

801054ed <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
801054ed:	55                   	push   %ebp
801054ee:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
801054f0:	eb 0c                	jmp    801054fe <strncmp+0x11>
    n--, p++, q++;
801054f2:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801054f6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
801054fa:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(n > 0 && *p && *p == *q)
801054fe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105502:	74 1a                	je     8010551e <strncmp+0x31>
80105504:	8b 45 08             	mov    0x8(%ebp),%eax
80105507:	0f b6 00             	movzbl (%eax),%eax
8010550a:	84 c0                	test   %al,%al
8010550c:	74 10                	je     8010551e <strncmp+0x31>
8010550e:	8b 45 08             	mov    0x8(%ebp),%eax
80105511:	0f b6 10             	movzbl (%eax),%edx
80105514:	8b 45 0c             	mov    0xc(%ebp),%eax
80105517:	0f b6 00             	movzbl (%eax),%eax
8010551a:	38 c2                	cmp    %al,%dl
8010551c:	74 d4                	je     801054f2 <strncmp+0x5>
  if(n == 0)
8010551e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105522:	75 07                	jne    8010552b <strncmp+0x3e>
    return 0;
80105524:	b8 00 00 00 00       	mov    $0x0,%eax
80105529:	eb 16                	jmp    80105541 <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
8010552b:	8b 45 08             	mov    0x8(%ebp),%eax
8010552e:	0f b6 00             	movzbl (%eax),%eax
80105531:	0f b6 d0             	movzbl %al,%edx
80105534:	8b 45 0c             	mov    0xc(%ebp),%eax
80105537:	0f b6 00             	movzbl (%eax),%eax
8010553a:	0f b6 c0             	movzbl %al,%eax
8010553d:	29 c2                	sub    %eax,%edx
8010553f:	89 d0                	mov    %edx,%eax
}
80105541:	5d                   	pop    %ebp
80105542:	c3                   	ret    

80105543 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105543:	55                   	push   %ebp
80105544:	89 e5                	mov    %esp,%ebp
80105546:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80105549:	8b 45 08             	mov    0x8(%ebp),%eax
8010554c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
8010554f:	90                   	nop
80105550:	8b 45 10             	mov    0x10(%ebp),%eax
80105553:	8d 50 ff             	lea    -0x1(%eax),%edx
80105556:	89 55 10             	mov    %edx,0x10(%ebp)
80105559:	85 c0                	test   %eax,%eax
8010555b:	7e 2c                	jle    80105589 <strncpy+0x46>
8010555d:	8b 45 08             	mov    0x8(%ebp),%eax
80105560:	8d 50 01             	lea    0x1(%eax),%edx
80105563:	89 55 08             	mov    %edx,0x8(%ebp)
80105566:	8b 55 0c             	mov    0xc(%ebp),%edx
80105569:	8d 4a 01             	lea    0x1(%edx),%ecx
8010556c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
8010556f:	0f b6 12             	movzbl (%edx),%edx
80105572:	88 10                	mov    %dl,(%eax)
80105574:	0f b6 00             	movzbl (%eax),%eax
80105577:	84 c0                	test   %al,%al
80105579:	75 d5                	jne    80105550 <strncpy+0xd>
    ;
  while(n-- > 0)
8010557b:	eb 0c                	jmp    80105589 <strncpy+0x46>
    *s++ = 0;
8010557d:	8b 45 08             	mov    0x8(%ebp),%eax
80105580:	8d 50 01             	lea    0x1(%eax),%edx
80105583:	89 55 08             	mov    %edx,0x8(%ebp)
80105586:	c6 00 00             	movb   $0x0,(%eax)
  while(n-- > 0)
80105589:	8b 45 10             	mov    0x10(%ebp),%eax
8010558c:	8d 50 ff             	lea    -0x1(%eax),%edx
8010558f:	89 55 10             	mov    %edx,0x10(%ebp)
80105592:	85 c0                	test   %eax,%eax
80105594:	7f e7                	jg     8010557d <strncpy+0x3a>
  return os;
80105596:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105599:	c9                   	leave  
8010559a:	c3                   	ret    

8010559b <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
8010559b:	55                   	push   %ebp
8010559c:	89 e5                	mov    %esp,%ebp
8010559e:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
801055a1:	8b 45 08             	mov    0x8(%ebp),%eax
801055a4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
801055a7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801055ab:	7f 05                	jg     801055b2 <safestrcpy+0x17>
    return os;
801055ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
801055b0:	eb 31                	jmp    801055e3 <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
801055b2:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801055b6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801055ba:	7e 1e                	jle    801055da <safestrcpy+0x3f>
801055bc:	8b 45 08             	mov    0x8(%ebp),%eax
801055bf:	8d 50 01             	lea    0x1(%eax),%edx
801055c2:	89 55 08             	mov    %edx,0x8(%ebp)
801055c5:	8b 55 0c             	mov    0xc(%ebp),%edx
801055c8:	8d 4a 01             	lea    0x1(%edx),%ecx
801055cb:	89 4d 0c             	mov    %ecx,0xc(%ebp)
801055ce:	0f b6 12             	movzbl (%edx),%edx
801055d1:	88 10                	mov    %dl,(%eax)
801055d3:	0f b6 00             	movzbl (%eax),%eax
801055d6:	84 c0                	test   %al,%al
801055d8:	75 d8                	jne    801055b2 <safestrcpy+0x17>
    ;
  *s = 0;
801055da:	8b 45 08             	mov    0x8(%ebp),%eax
801055dd:	c6 00 00             	movb   $0x0,(%eax)
  return os;
801055e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801055e3:	c9                   	leave  
801055e4:	c3                   	ret    

801055e5 <strlen>:

int
strlen(const char *s)
{
801055e5:	55                   	push   %ebp
801055e6:	89 e5                	mov    %esp,%ebp
801055e8:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
801055eb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801055f2:	eb 04                	jmp    801055f8 <strlen+0x13>
801055f4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801055f8:	8b 55 fc             	mov    -0x4(%ebp),%edx
801055fb:	8b 45 08             	mov    0x8(%ebp),%eax
801055fe:	01 d0                	add    %edx,%eax
80105600:	0f b6 00             	movzbl (%eax),%eax
80105603:	84 c0                	test   %al,%al
80105605:	75 ed                	jne    801055f4 <strlen+0xf>
    ;
  return n;
80105607:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010560a:	c9                   	leave  
8010560b:	c3                   	ret    

8010560c <swtch>:
8010560c:	8b 44 24 04          	mov    0x4(%esp),%eax
80105610:	8b 54 24 08          	mov    0x8(%esp),%edx
80105614:	55                   	push   %ebp
80105615:	53                   	push   %ebx
80105616:	56                   	push   %esi
80105617:	57                   	push   %edi
80105618:	89 20                	mov    %esp,(%eax)
8010561a:	89 d4                	mov    %edx,%esp
8010561c:	5f                   	pop    %edi
8010561d:	5e                   	pop    %esi
8010561e:	5b                   	pop    %ebx
8010561f:	5d                   	pop    %ebp
80105620:	c3                   	ret    

80105621 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105621:	55                   	push   %ebp
80105622:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
80105624:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010562a:	8b 00                	mov    (%eax),%eax
8010562c:	3b 45 08             	cmp    0x8(%ebp),%eax
8010562f:	76 12                	jbe    80105643 <fetchint+0x22>
80105631:	8b 45 08             	mov    0x8(%ebp),%eax
80105634:	8d 50 04             	lea    0x4(%eax),%edx
80105637:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010563d:	8b 00                	mov    (%eax),%eax
8010563f:	39 c2                	cmp    %eax,%edx
80105641:	76 07                	jbe    8010564a <fetchint+0x29>
    return -1;
80105643:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105648:	eb 0f                	jmp    80105659 <fetchint+0x38>
  *ip = *(int*)(addr);
8010564a:	8b 45 08             	mov    0x8(%ebp),%eax
8010564d:	8b 10                	mov    (%eax),%edx
8010564f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105652:	89 10                	mov    %edx,(%eax)
  return 0;
80105654:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105659:	5d                   	pop    %ebp
8010565a:	c3                   	ret    

8010565b <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
8010565b:	55                   	push   %ebp
8010565c:	89 e5                	mov    %esp,%ebp
8010565e:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
80105661:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105667:	8b 00                	mov    (%eax),%eax
80105669:	3b 45 08             	cmp    0x8(%ebp),%eax
8010566c:	77 07                	ja     80105675 <fetchstr+0x1a>
    return -1;
8010566e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105673:	eb 46                	jmp    801056bb <fetchstr+0x60>
  *pp = (char*)addr;
80105675:	8b 55 08             	mov    0x8(%ebp),%edx
80105678:	8b 45 0c             	mov    0xc(%ebp),%eax
8010567b:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
8010567d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105683:	8b 00                	mov    (%eax),%eax
80105685:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
80105688:	8b 45 0c             	mov    0xc(%ebp),%eax
8010568b:	8b 00                	mov    (%eax),%eax
8010568d:	89 45 fc             	mov    %eax,-0x4(%ebp)
80105690:	eb 1c                	jmp    801056ae <fetchstr+0x53>
    if(*s == 0)
80105692:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105695:	0f b6 00             	movzbl (%eax),%eax
80105698:	84 c0                	test   %al,%al
8010569a:	75 0e                	jne    801056aa <fetchstr+0x4f>
      return s - *pp;
8010569c:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010569f:	8b 45 0c             	mov    0xc(%ebp),%eax
801056a2:	8b 00                	mov    (%eax),%eax
801056a4:	29 c2                	sub    %eax,%edx
801056a6:	89 d0                	mov    %edx,%eax
801056a8:	eb 11                	jmp    801056bb <fetchstr+0x60>
  for(s = *pp; s < ep; s++)
801056aa:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801056ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
801056b1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801056b4:	72 dc                	jb     80105692 <fetchstr+0x37>
  return -1;
801056b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056bb:	c9                   	leave  
801056bc:	c3                   	ret    

801056bd <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801056bd:	55                   	push   %ebp
801056be:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
801056c0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801056c6:	8b 40 18             	mov    0x18(%eax),%eax
801056c9:	8b 40 44             	mov    0x44(%eax),%eax
801056cc:	8b 55 08             	mov    0x8(%ebp),%edx
801056cf:	c1 e2 02             	shl    $0x2,%edx
801056d2:	01 d0                	add    %edx,%eax
801056d4:	83 c0 04             	add    $0x4,%eax
801056d7:	ff 75 0c             	pushl  0xc(%ebp)
801056da:	50                   	push   %eax
801056db:	e8 41 ff ff ff       	call   80105621 <fetchint>
801056e0:	83 c4 08             	add    $0x8,%esp
}
801056e3:	c9                   	leave  
801056e4:	c3                   	ret    

801056e5 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801056e5:	55                   	push   %ebp
801056e6:	89 e5                	mov    %esp,%ebp
801056e8:	83 ec 10             	sub    $0x10,%esp
  int i;
  
  if(argint(n, &i) < 0)
801056eb:	8d 45 fc             	lea    -0x4(%ebp),%eax
801056ee:	50                   	push   %eax
801056ef:	ff 75 08             	pushl  0x8(%ebp)
801056f2:	e8 c6 ff ff ff       	call   801056bd <argint>
801056f7:	83 c4 08             	add    $0x8,%esp
801056fa:	85 c0                	test   %eax,%eax
801056fc:	79 07                	jns    80105705 <argptr+0x20>
    return -1;
801056fe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105703:	eb 3b                	jmp    80105740 <argptr+0x5b>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
80105705:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010570b:	8b 00                	mov    (%eax),%eax
8010570d:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105710:	39 d0                	cmp    %edx,%eax
80105712:	76 16                	jbe    8010572a <argptr+0x45>
80105714:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105717:	89 c2                	mov    %eax,%edx
80105719:	8b 45 10             	mov    0x10(%ebp),%eax
8010571c:	01 c2                	add    %eax,%edx
8010571e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105724:	8b 00                	mov    (%eax),%eax
80105726:	39 c2                	cmp    %eax,%edx
80105728:	76 07                	jbe    80105731 <argptr+0x4c>
    return -1;
8010572a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010572f:	eb 0f                	jmp    80105740 <argptr+0x5b>
  *pp = (char*)i;
80105731:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105734:	89 c2                	mov    %eax,%edx
80105736:	8b 45 0c             	mov    0xc(%ebp),%eax
80105739:	89 10                	mov    %edx,(%eax)
  return 0;
8010573b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105740:	c9                   	leave  
80105741:	c3                   	ret    

80105742 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105742:	55                   	push   %ebp
80105743:	89 e5                	mov    %esp,%ebp
80105745:	83 ec 10             	sub    $0x10,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105748:	8d 45 fc             	lea    -0x4(%ebp),%eax
8010574b:	50                   	push   %eax
8010574c:	ff 75 08             	pushl  0x8(%ebp)
8010574f:	e8 69 ff ff ff       	call   801056bd <argint>
80105754:	83 c4 08             	add    $0x8,%esp
80105757:	85 c0                	test   %eax,%eax
80105759:	79 07                	jns    80105762 <argstr+0x20>
    return -1;
8010575b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105760:	eb 0f                	jmp    80105771 <argstr+0x2f>
  return fetchstr(addr, pp);
80105762:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105765:	ff 75 0c             	pushl  0xc(%ebp)
80105768:	50                   	push   %eax
80105769:	e8 ed fe ff ff       	call   8010565b <fetchstr>
8010576e:	83 c4 08             	add    $0x8,%esp
}
80105771:	c9                   	leave  
80105772:	c3                   	ret    

80105773 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
80105773:	55                   	push   %ebp
80105774:	89 e5                	mov    %esp,%ebp
80105776:	53                   	push   %ebx
80105777:	83 ec 14             	sub    $0x14,%esp
  int num;

  num = proc->tf->eax;
8010577a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105780:	8b 40 18             	mov    0x18(%eax),%eax
80105783:	8b 40 1c             	mov    0x1c(%eax),%eax
80105786:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105789:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010578d:	7e 30                	jle    801057bf <syscall+0x4c>
8010578f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105792:	83 f8 15             	cmp    $0x15,%eax
80105795:	77 28                	ja     801057bf <syscall+0x4c>
80105797:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010579a:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
801057a1:	85 c0                	test   %eax,%eax
801057a3:	74 1a                	je     801057bf <syscall+0x4c>
    proc->tf->eax = syscalls[num]();
801057a5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801057ab:	8b 58 18             	mov    0x18(%eax),%ebx
801057ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057b1:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
801057b8:	ff d0                	call   *%eax
801057ba:	89 43 1c             	mov    %eax,0x1c(%ebx)
801057bd:	eb 34                	jmp    801057f3 <syscall+0x80>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
801057bf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801057c5:	8d 50 6c             	lea    0x6c(%eax),%edx
801057c8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    cprintf("%d %s: unknown sys call %d\n",
801057ce:	8b 40 10             	mov    0x10(%eax),%eax
801057d1:	ff 75 f4             	pushl  -0xc(%ebp)
801057d4:	52                   	push   %edx
801057d5:	50                   	push   %eax
801057d6:	68 04 8b 10 80       	push   $0x80108b04
801057db:	e8 e6 ab ff ff       	call   801003c6 <cprintf>
801057e0:	83 c4 10             	add    $0x10,%esp
    proc->tf->eax = -1;
801057e3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801057e9:	8b 40 18             	mov    0x18(%eax),%eax
801057ec:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
801057f3:	90                   	nop
801057f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801057f7:	c9                   	leave  
801057f8:	c3                   	ret    

801057f9 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
801057f9:	55                   	push   %ebp
801057fa:	89 e5                	mov    %esp,%ebp
801057fc:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
801057ff:	83 ec 08             	sub    $0x8,%esp
80105802:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105805:	50                   	push   %eax
80105806:	ff 75 08             	pushl  0x8(%ebp)
80105809:	e8 af fe ff ff       	call   801056bd <argint>
8010580e:	83 c4 10             	add    $0x10,%esp
80105811:	85 c0                	test   %eax,%eax
80105813:	79 07                	jns    8010581c <argfd+0x23>
    return -1;
80105815:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010581a:	eb 50                	jmp    8010586c <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
8010581c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010581f:	85 c0                	test   %eax,%eax
80105821:	78 21                	js     80105844 <argfd+0x4b>
80105823:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105826:	83 f8 0f             	cmp    $0xf,%eax
80105829:	7f 19                	jg     80105844 <argfd+0x4b>
8010582b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105831:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105834:	83 c2 08             	add    $0x8,%edx
80105837:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010583b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010583e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105842:	75 07                	jne    8010584b <argfd+0x52>
    return -1;
80105844:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105849:	eb 21                	jmp    8010586c <argfd+0x73>
  if(pfd)
8010584b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010584f:	74 08                	je     80105859 <argfd+0x60>
    *pfd = fd;
80105851:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105854:	8b 45 0c             	mov    0xc(%ebp),%eax
80105857:	89 10                	mov    %edx,(%eax)
  if(pf)
80105859:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010585d:	74 08                	je     80105867 <argfd+0x6e>
    *pf = f;
8010585f:	8b 45 10             	mov    0x10(%ebp),%eax
80105862:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105865:	89 10                	mov    %edx,(%eax)
  return 0;
80105867:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010586c:	c9                   	leave  
8010586d:	c3                   	ret    

8010586e <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
8010586e:	55                   	push   %ebp
8010586f:	89 e5                	mov    %esp,%ebp
80105871:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105874:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
8010587b:	eb 30                	jmp    801058ad <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
8010587d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105883:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105886:	83 c2 08             	add    $0x8,%edx
80105889:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010588d:	85 c0                	test   %eax,%eax
8010588f:	75 18                	jne    801058a9 <fdalloc+0x3b>
      proc->ofile[fd] = f;
80105891:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105897:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010589a:	8d 4a 08             	lea    0x8(%edx),%ecx
8010589d:	8b 55 08             	mov    0x8(%ebp),%edx
801058a0:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
801058a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
801058a7:	eb 0f                	jmp    801058b8 <fdalloc+0x4a>
  for(fd = 0; fd < NOFILE; fd++){
801058a9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801058ad:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
801058b1:	7e ca                	jle    8010587d <fdalloc+0xf>
    }
  }
  return -1;
801058b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801058b8:	c9                   	leave  
801058b9:	c3                   	ret    

801058ba <sys_dup>:

int
sys_dup(void)
{
801058ba:	55                   	push   %ebp
801058bb:	89 e5                	mov    %esp,%ebp
801058bd:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
801058c0:	83 ec 04             	sub    $0x4,%esp
801058c3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801058c6:	50                   	push   %eax
801058c7:	6a 00                	push   $0x0
801058c9:	6a 00                	push   $0x0
801058cb:	e8 29 ff ff ff       	call   801057f9 <argfd>
801058d0:	83 c4 10             	add    $0x10,%esp
801058d3:	85 c0                	test   %eax,%eax
801058d5:	79 07                	jns    801058de <sys_dup+0x24>
    return -1;
801058d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058dc:	eb 31                	jmp    8010590f <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
801058de:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058e1:	83 ec 0c             	sub    $0xc,%esp
801058e4:	50                   	push   %eax
801058e5:	e8 84 ff ff ff       	call   8010586e <fdalloc>
801058ea:	83 c4 10             	add    $0x10,%esp
801058ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
801058f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801058f4:	79 07                	jns    801058fd <sys_dup+0x43>
    return -1;
801058f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058fb:	eb 12                	jmp    8010590f <sys_dup+0x55>
  filedup(f);
801058fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105900:	83 ec 0c             	sub    $0xc,%esp
80105903:	50                   	push   %eax
80105904:	e8 f7 b6 ff ff       	call   80101000 <filedup>
80105909:	83 c4 10             	add    $0x10,%esp
  return fd;
8010590c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010590f:	c9                   	leave  
80105910:	c3                   	ret    

80105911 <sys_read>:

int
sys_read(void)
{
80105911:	55                   	push   %ebp
80105912:	89 e5                	mov    %esp,%ebp
80105914:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105917:	83 ec 04             	sub    $0x4,%esp
8010591a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010591d:	50                   	push   %eax
8010591e:	6a 00                	push   $0x0
80105920:	6a 00                	push   $0x0
80105922:	e8 d2 fe ff ff       	call   801057f9 <argfd>
80105927:	83 c4 10             	add    $0x10,%esp
8010592a:	85 c0                	test   %eax,%eax
8010592c:	78 2e                	js     8010595c <sys_read+0x4b>
8010592e:	83 ec 08             	sub    $0x8,%esp
80105931:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105934:	50                   	push   %eax
80105935:	6a 02                	push   $0x2
80105937:	e8 81 fd ff ff       	call   801056bd <argint>
8010593c:	83 c4 10             	add    $0x10,%esp
8010593f:	85 c0                	test   %eax,%eax
80105941:	78 19                	js     8010595c <sys_read+0x4b>
80105943:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105946:	83 ec 04             	sub    $0x4,%esp
80105949:	50                   	push   %eax
8010594a:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010594d:	50                   	push   %eax
8010594e:	6a 01                	push   $0x1
80105950:	e8 90 fd ff ff       	call   801056e5 <argptr>
80105955:	83 c4 10             	add    $0x10,%esp
80105958:	85 c0                	test   %eax,%eax
8010595a:	79 07                	jns    80105963 <sys_read+0x52>
    return -1;
8010595c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105961:	eb 17                	jmp    8010597a <sys_read+0x69>
  return fileread(f, p, n);
80105963:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105966:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105969:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010596c:	83 ec 04             	sub    $0x4,%esp
8010596f:	51                   	push   %ecx
80105970:	52                   	push   %edx
80105971:	50                   	push   %eax
80105972:	e8 19 b8 ff ff       	call   80101190 <fileread>
80105977:	83 c4 10             	add    $0x10,%esp
}
8010597a:	c9                   	leave  
8010597b:	c3                   	ret    

8010597c <sys_write>:

int
sys_write(void)
{
8010597c:	55                   	push   %ebp
8010597d:	89 e5                	mov    %esp,%ebp
8010597f:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105982:	83 ec 04             	sub    $0x4,%esp
80105985:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105988:	50                   	push   %eax
80105989:	6a 00                	push   $0x0
8010598b:	6a 00                	push   $0x0
8010598d:	e8 67 fe ff ff       	call   801057f9 <argfd>
80105992:	83 c4 10             	add    $0x10,%esp
80105995:	85 c0                	test   %eax,%eax
80105997:	78 2e                	js     801059c7 <sys_write+0x4b>
80105999:	83 ec 08             	sub    $0x8,%esp
8010599c:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010599f:	50                   	push   %eax
801059a0:	6a 02                	push   $0x2
801059a2:	e8 16 fd ff ff       	call   801056bd <argint>
801059a7:	83 c4 10             	add    $0x10,%esp
801059aa:	85 c0                	test   %eax,%eax
801059ac:	78 19                	js     801059c7 <sys_write+0x4b>
801059ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059b1:	83 ec 04             	sub    $0x4,%esp
801059b4:	50                   	push   %eax
801059b5:	8d 45 ec             	lea    -0x14(%ebp),%eax
801059b8:	50                   	push   %eax
801059b9:	6a 01                	push   $0x1
801059bb:	e8 25 fd ff ff       	call   801056e5 <argptr>
801059c0:	83 c4 10             	add    $0x10,%esp
801059c3:	85 c0                	test   %eax,%eax
801059c5:	79 07                	jns    801059ce <sys_write+0x52>
    return -1;
801059c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059cc:	eb 17                	jmp    801059e5 <sys_write+0x69>
  return filewrite(f, p, n);
801059ce:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801059d1:	8b 55 ec             	mov    -0x14(%ebp),%edx
801059d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059d7:	83 ec 04             	sub    $0x4,%esp
801059da:	51                   	push   %ecx
801059db:	52                   	push   %edx
801059dc:	50                   	push   %eax
801059dd:	e8 66 b8 ff ff       	call   80101248 <filewrite>
801059e2:	83 c4 10             	add    $0x10,%esp
}
801059e5:	c9                   	leave  
801059e6:	c3                   	ret    

801059e7 <sys_close>:

int
sys_close(void)
{
801059e7:	55                   	push   %ebp
801059e8:	89 e5                	mov    %esp,%ebp
801059ea:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
801059ed:	83 ec 04             	sub    $0x4,%esp
801059f0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801059f3:	50                   	push   %eax
801059f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059f7:	50                   	push   %eax
801059f8:	6a 00                	push   $0x0
801059fa:	e8 fa fd ff ff       	call   801057f9 <argfd>
801059ff:	83 c4 10             	add    $0x10,%esp
80105a02:	85 c0                	test   %eax,%eax
80105a04:	79 07                	jns    80105a0d <sys_close+0x26>
    return -1;
80105a06:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a0b:	eb 28                	jmp    80105a35 <sys_close+0x4e>
  proc->ofile[fd] = 0;
80105a0d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a13:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105a16:	83 c2 08             	add    $0x8,%edx
80105a19:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105a20:	00 
  fileclose(f);
80105a21:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a24:	83 ec 0c             	sub    $0xc,%esp
80105a27:	50                   	push   %eax
80105a28:	e8 24 b6 ff ff       	call   80101051 <fileclose>
80105a2d:	83 c4 10             	add    $0x10,%esp
  return 0;
80105a30:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105a35:	c9                   	leave  
80105a36:	c3                   	ret    

80105a37 <sys_fstat>:

int
sys_fstat(void)
{
80105a37:	55                   	push   %ebp
80105a38:	89 e5                	mov    %esp,%ebp
80105a3a:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105a3d:	83 ec 04             	sub    $0x4,%esp
80105a40:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a43:	50                   	push   %eax
80105a44:	6a 00                	push   $0x0
80105a46:	6a 00                	push   $0x0
80105a48:	e8 ac fd ff ff       	call   801057f9 <argfd>
80105a4d:	83 c4 10             	add    $0x10,%esp
80105a50:	85 c0                	test   %eax,%eax
80105a52:	78 17                	js     80105a6b <sys_fstat+0x34>
80105a54:	83 ec 04             	sub    $0x4,%esp
80105a57:	6a 14                	push   $0x14
80105a59:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a5c:	50                   	push   %eax
80105a5d:	6a 01                	push   $0x1
80105a5f:	e8 81 fc ff ff       	call   801056e5 <argptr>
80105a64:	83 c4 10             	add    $0x10,%esp
80105a67:	85 c0                	test   %eax,%eax
80105a69:	79 07                	jns    80105a72 <sys_fstat+0x3b>
    return -1;
80105a6b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a70:	eb 13                	jmp    80105a85 <sys_fstat+0x4e>
  return filestat(f, st);
80105a72:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105a75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a78:	83 ec 08             	sub    $0x8,%esp
80105a7b:	52                   	push   %edx
80105a7c:	50                   	push   %eax
80105a7d:	e8 b7 b6 ff ff       	call   80101139 <filestat>
80105a82:	83 c4 10             	add    $0x10,%esp
}
80105a85:	c9                   	leave  
80105a86:	c3                   	ret    

80105a87 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105a87:	55                   	push   %ebp
80105a88:	89 e5                	mov    %esp,%ebp
80105a8a:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105a8d:	83 ec 08             	sub    $0x8,%esp
80105a90:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105a93:	50                   	push   %eax
80105a94:	6a 00                	push   $0x0
80105a96:	e8 a7 fc ff ff       	call   80105742 <argstr>
80105a9b:	83 c4 10             	add    $0x10,%esp
80105a9e:	85 c0                	test   %eax,%eax
80105aa0:	78 15                	js     80105ab7 <sys_link+0x30>
80105aa2:	83 ec 08             	sub    $0x8,%esp
80105aa5:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105aa8:	50                   	push   %eax
80105aa9:	6a 01                	push   $0x1
80105aab:	e8 92 fc ff ff       	call   80105742 <argstr>
80105ab0:	83 c4 10             	add    $0x10,%esp
80105ab3:	85 c0                	test   %eax,%eax
80105ab5:	79 0a                	jns    80105ac1 <sys_link+0x3a>
    return -1;
80105ab7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105abc:	e9 68 01 00 00       	jmp    80105c29 <sys_link+0x1a2>

  begin_op();
80105ac1:	e8 87 da ff ff       	call   8010354d <begin_op>
  if((ip = namei(old)) == 0){
80105ac6:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105ac9:	83 ec 0c             	sub    $0xc,%esp
80105acc:	50                   	push   %eax
80105acd:	e8 56 ca ff ff       	call   80102528 <namei>
80105ad2:	83 c4 10             	add    $0x10,%esp
80105ad5:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105ad8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105adc:	75 0f                	jne    80105aed <sys_link+0x66>
    end_op();
80105ade:	e8 f6 da ff ff       	call   801035d9 <end_op>
    return -1;
80105ae3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ae8:	e9 3c 01 00 00       	jmp    80105c29 <sys_link+0x1a2>
  }

  ilock(ip);
80105aed:	83 ec 0c             	sub    $0xc,%esp
80105af0:	ff 75 f4             	pushl  -0xc(%ebp)
80105af3:	e8 72 be ff ff       	call   8010196a <ilock>
80105af8:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
80105afb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105afe:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105b02:	66 83 f8 01          	cmp    $0x1,%ax
80105b06:	75 1d                	jne    80105b25 <sys_link+0x9e>
    iunlockput(ip);
80105b08:	83 ec 0c             	sub    $0xc,%esp
80105b0b:	ff 75 f4             	pushl  -0xc(%ebp)
80105b0e:	e8 17 c1 ff ff       	call   80101c2a <iunlockput>
80105b13:	83 c4 10             	add    $0x10,%esp
    end_op();
80105b16:	e8 be da ff ff       	call   801035d9 <end_op>
    return -1;
80105b1b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b20:	e9 04 01 00 00       	jmp    80105c29 <sys_link+0x1a2>
  }

  ip->nlink++;
80105b25:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b28:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105b2c:	83 c0 01             	add    $0x1,%eax
80105b2f:	89 c2                	mov    %eax,%edx
80105b31:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b34:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105b38:	83 ec 0c             	sub    $0xc,%esp
80105b3b:	ff 75 f4             	pushl  -0xc(%ebp)
80105b3e:	e8 4d bc ff ff       	call   80101790 <iupdate>
80105b43:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
80105b46:	83 ec 0c             	sub    $0xc,%esp
80105b49:	ff 75 f4             	pushl  -0xc(%ebp)
80105b4c:	e8 77 bf ff ff       	call   80101ac8 <iunlock>
80105b51:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
80105b54:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105b57:	83 ec 08             	sub    $0x8,%esp
80105b5a:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80105b5d:	52                   	push   %edx
80105b5e:	50                   	push   %eax
80105b5f:	e8 e0 c9 ff ff       	call   80102544 <nameiparent>
80105b64:	83 c4 10             	add    $0x10,%esp
80105b67:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105b6a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105b6e:	74 71                	je     80105be1 <sys_link+0x15a>
    goto bad;
  ilock(dp);
80105b70:	83 ec 0c             	sub    $0xc,%esp
80105b73:	ff 75 f0             	pushl  -0x10(%ebp)
80105b76:	e8 ef bd ff ff       	call   8010196a <ilock>
80105b7b:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105b7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b81:	8b 10                	mov    (%eax),%edx
80105b83:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b86:	8b 00                	mov    (%eax),%eax
80105b88:	39 c2                	cmp    %eax,%edx
80105b8a:	75 1d                	jne    80105ba9 <sys_link+0x122>
80105b8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b8f:	8b 40 04             	mov    0x4(%eax),%eax
80105b92:	83 ec 04             	sub    $0x4,%esp
80105b95:	50                   	push   %eax
80105b96:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80105b99:	50                   	push   %eax
80105b9a:	ff 75 f0             	pushl  -0x10(%ebp)
80105b9d:	e8 ea c6 ff ff       	call   8010228c <dirlink>
80105ba2:	83 c4 10             	add    $0x10,%esp
80105ba5:	85 c0                	test   %eax,%eax
80105ba7:	79 10                	jns    80105bb9 <sys_link+0x132>
    iunlockput(dp);
80105ba9:	83 ec 0c             	sub    $0xc,%esp
80105bac:	ff 75 f0             	pushl  -0x10(%ebp)
80105baf:	e8 76 c0 ff ff       	call   80101c2a <iunlockput>
80105bb4:	83 c4 10             	add    $0x10,%esp
    goto bad;
80105bb7:	eb 29                	jmp    80105be2 <sys_link+0x15b>
  }
  iunlockput(dp);
80105bb9:	83 ec 0c             	sub    $0xc,%esp
80105bbc:	ff 75 f0             	pushl  -0x10(%ebp)
80105bbf:	e8 66 c0 ff ff       	call   80101c2a <iunlockput>
80105bc4:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80105bc7:	83 ec 0c             	sub    $0xc,%esp
80105bca:	ff 75 f4             	pushl  -0xc(%ebp)
80105bcd:	e8 68 bf ff ff       	call   80101b3a <iput>
80105bd2:	83 c4 10             	add    $0x10,%esp

  end_op();
80105bd5:	e8 ff d9 ff ff       	call   801035d9 <end_op>

  return 0;
80105bda:	b8 00 00 00 00       	mov    $0x0,%eax
80105bdf:	eb 48                	jmp    80105c29 <sys_link+0x1a2>
    goto bad;
80105be1:	90                   	nop

bad:
  ilock(ip);
80105be2:	83 ec 0c             	sub    $0xc,%esp
80105be5:	ff 75 f4             	pushl  -0xc(%ebp)
80105be8:	e8 7d bd ff ff       	call   8010196a <ilock>
80105bed:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
80105bf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bf3:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105bf7:	83 e8 01             	sub    $0x1,%eax
80105bfa:	89 c2                	mov    %eax,%edx
80105bfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bff:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105c03:	83 ec 0c             	sub    $0xc,%esp
80105c06:	ff 75 f4             	pushl  -0xc(%ebp)
80105c09:	e8 82 bb ff ff       	call   80101790 <iupdate>
80105c0e:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80105c11:	83 ec 0c             	sub    $0xc,%esp
80105c14:	ff 75 f4             	pushl  -0xc(%ebp)
80105c17:	e8 0e c0 ff ff       	call   80101c2a <iunlockput>
80105c1c:	83 c4 10             	add    $0x10,%esp
  end_op();
80105c1f:	e8 b5 d9 ff ff       	call   801035d9 <end_op>
  return -1;
80105c24:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c29:	c9                   	leave  
80105c2a:	c3                   	ret    

80105c2b <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80105c2b:	55                   	push   %ebp
80105c2c:	89 e5                	mov    %esp,%ebp
80105c2e:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105c31:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80105c38:	eb 40                	jmp    80105c7a <isdirempty+0x4f>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105c3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c3d:	6a 10                	push   $0x10
80105c3f:	50                   	push   %eax
80105c40:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105c43:	50                   	push   %eax
80105c44:	ff 75 08             	pushl  0x8(%ebp)
80105c47:	e8 8c c2 ff ff       	call   80101ed8 <readi>
80105c4c:	83 c4 10             	add    $0x10,%esp
80105c4f:	83 f8 10             	cmp    $0x10,%eax
80105c52:	74 0d                	je     80105c61 <isdirempty+0x36>
      panic("isdirempty: readi");
80105c54:	83 ec 0c             	sub    $0xc,%esp
80105c57:	68 20 8b 10 80       	push   $0x80108b20
80105c5c:	e8 05 a9 ff ff       	call   80100566 <panic>
    if(de.inum != 0)
80105c61:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80105c65:	66 85 c0             	test   %ax,%ax
80105c68:	74 07                	je     80105c71 <isdirempty+0x46>
      return 0;
80105c6a:	b8 00 00 00 00       	mov    $0x0,%eax
80105c6f:	eb 1b                	jmp    80105c8c <isdirempty+0x61>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105c71:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c74:	83 c0 10             	add    $0x10,%eax
80105c77:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105c7a:	8b 45 08             	mov    0x8(%ebp),%eax
80105c7d:	8b 50 18             	mov    0x18(%eax),%edx
80105c80:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c83:	39 c2                	cmp    %eax,%edx
80105c85:	77 b3                	ja     80105c3a <isdirempty+0xf>
  }
  return 1;
80105c87:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105c8c:	c9                   	leave  
80105c8d:	c3                   	ret    

80105c8e <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105c8e:	55                   	push   %ebp
80105c8f:	89 e5                	mov    %esp,%ebp
80105c91:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105c94:	83 ec 08             	sub    $0x8,%esp
80105c97:	8d 45 cc             	lea    -0x34(%ebp),%eax
80105c9a:	50                   	push   %eax
80105c9b:	6a 00                	push   $0x0
80105c9d:	e8 a0 fa ff ff       	call   80105742 <argstr>
80105ca2:	83 c4 10             	add    $0x10,%esp
80105ca5:	85 c0                	test   %eax,%eax
80105ca7:	79 0a                	jns    80105cb3 <sys_unlink+0x25>
    return -1;
80105ca9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cae:	e9 bc 01 00 00       	jmp    80105e6f <sys_unlink+0x1e1>

  begin_op();
80105cb3:	e8 95 d8 ff ff       	call   8010354d <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105cb8:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105cbb:	83 ec 08             	sub    $0x8,%esp
80105cbe:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80105cc1:	52                   	push   %edx
80105cc2:	50                   	push   %eax
80105cc3:	e8 7c c8 ff ff       	call   80102544 <nameiparent>
80105cc8:	83 c4 10             	add    $0x10,%esp
80105ccb:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105cce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105cd2:	75 0f                	jne    80105ce3 <sys_unlink+0x55>
    end_op();
80105cd4:	e8 00 d9 ff ff       	call   801035d9 <end_op>
    return -1;
80105cd9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cde:	e9 8c 01 00 00       	jmp    80105e6f <sys_unlink+0x1e1>
  }

  ilock(dp);
80105ce3:	83 ec 0c             	sub    $0xc,%esp
80105ce6:	ff 75 f4             	pushl  -0xc(%ebp)
80105ce9:	e8 7c bc ff ff       	call   8010196a <ilock>
80105cee:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105cf1:	83 ec 08             	sub    $0x8,%esp
80105cf4:	68 32 8b 10 80       	push   $0x80108b32
80105cf9:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105cfc:	50                   	push   %eax
80105cfd:	e8 b5 c4 ff ff       	call   801021b7 <namecmp>
80105d02:	83 c4 10             	add    $0x10,%esp
80105d05:	85 c0                	test   %eax,%eax
80105d07:	0f 84 4a 01 00 00    	je     80105e57 <sys_unlink+0x1c9>
80105d0d:	83 ec 08             	sub    $0x8,%esp
80105d10:	68 34 8b 10 80       	push   $0x80108b34
80105d15:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105d18:	50                   	push   %eax
80105d19:	e8 99 c4 ff ff       	call   801021b7 <namecmp>
80105d1e:	83 c4 10             	add    $0x10,%esp
80105d21:	85 c0                	test   %eax,%eax
80105d23:	0f 84 2e 01 00 00    	je     80105e57 <sys_unlink+0x1c9>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105d29:	83 ec 04             	sub    $0x4,%esp
80105d2c:	8d 45 c8             	lea    -0x38(%ebp),%eax
80105d2f:	50                   	push   %eax
80105d30:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105d33:	50                   	push   %eax
80105d34:	ff 75 f4             	pushl  -0xc(%ebp)
80105d37:	e8 96 c4 ff ff       	call   801021d2 <dirlookup>
80105d3c:	83 c4 10             	add    $0x10,%esp
80105d3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105d42:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105d46:	0f 84 0a 01 00 00    	je     80105e56 <sys_unlink+0x1c8>
    goto bad;
  ilock(ip);
80105d4c:	83 ec 0c             	sub    $0xc,%esp
80105d4f:	ff 75 f0             	pushl  -0x10(%ebp)
80105d52:	e8 13 bc ff ff       	call   8010196a <ilock>
80105d57:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
80105d5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d5d:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105d61:	66 85 c0             	test   %ax,%ax
80105d64:	7f 0d                	jg     80105d73 <sys_unlink+0xe5>
    panic("unlink: nlink < 1");
80105d66:	83 ec 0c             	sub    $0xc,%esp
80105d69:	68 37 8b 10 80       	push   $0x80108b37
80105d6e:	e8 f3 a7 ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105d73:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d76:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105d7a:	66 83 f8 01          	cmp    $0x1,%ax
80105d7e:	75 25                	jne    80105da5 <sys_unlink+0x117>
80105d80:	83 ec 0c             	sub    $0xc,%esp
80105d83:	ff 75 f0             	pushl  -0x10(%ebp)
80105d86:	e8 a0 fe ff ff       	call   80105c2b <isdirempty>
80105d8b:	83 c4 10             	add    $0x10,%esp
80105d8e:	85 c0                	test   %eax,%eax
80105d90:	75 13                	jne    80105da5 <sys_unlink+0x117>
    iunlockput(ip);
80105d92:	83 ec 0c             	sub    $0xc,%esp
80105d95:	ff 75 f0             	pushl  -0x10(%ebp)
80105d98:	e8 8d be ff ff       	call   80101c2a <iunlockput>
80105d9d:	83 c4 10             	add    $0x10,%esp
    goto bad;
80105da0:	e9 b2 00 00 00       	jmp    80105e57 <sys_unlink+0x1c9>
  }

  memset(&de, 0, sizeof(de));
80105da5:	83 ec 04             	sub    $0x4,%esp
80105da8:	6a 10                	push   $0x10
80105daa:	6a 00                	push   $0x0
80105dac:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105daf:	50                   	push   %eax
80105db0:	e8 e3 f5 ff ff       	call   80105398 <memset>
80105db5:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105db8:	8b 45 c8             	mov    -0x38(%ebp),%eax
80105dbb:	6a 10                	push   $0x10
80105dbd:	50                   	push   %eax
80105dbe:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105dc1:	50                   	push   %eax
80105dc2:	ff 75 f4             	pushl  -0xc(%ebp)
80105dc5:	e8 65 c2 ff ff       	call   8010202f <writei>
80105dca:	83 c4 10             	add    $0x10,%esp
80105dcd:	83 f8 10             	cmp    $0x10,%eax
80105dd0:	74 0d                	je     80105ddf <sys_unlink+0x151>
    panic("unlink: writei");
80105dd2:	83 ec 0c             	sub    $0xc,%esp
80105dd5:	68 49 8b 10 80       	push   $0x80108b49
80105dda:	e8 87 a7 ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR){
80105ddf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105de2:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105de6:	66 83 f8 01          	cmp    $0x1,%ax
80105dea:	75 21                	jne    80105e0d <sys_unlink+0x17f>
    dp->nlink--;
80105dec:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105def:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105df3:	83 e8 01             	sub    $0x1,%eax
80105df6:	89 c2                	mov    %eax,%edx
80105df8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105dfb:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80105dff:	83 ec 0c             	sub    $0xc,%esp
80105e02:	ff 75 f4             	pushl  -0xc(%ebp)
80105e05:	e8 86 b9 ff ff       	call   80101790 <iupdate>
80105e0a:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
80105e0d:	83 ec 0c             	sub    $0xc,%esp
80105e10:	ff 75 f4             	pushl  -0xc(%ebp)
80105e13:	e8 12 be ff ff       	call   80101c2a <iunlockput>
80105e18:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
80105e1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e1e:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105e22:	83 e8 01             	sub    $0x1,%eax
80105e25:	89 c2                	mov    %eax,%edx
80105e27:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e2a:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105e2e:	83 ec 0c             	sub    $0xc,%esp
80105e31:	ff 75 f0             	pushl  -0x10(%ebp)
80105e34:	e8 57 b9 ff ff       	call   80101790 <iupdate>
80105e39:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80105e3c:	83 ec 0c             	sub    $0xc,%esp
80105e3f:	ff 75 f0             	pushl  -0x10(%ebp)
80105e42:	e8 e3 bd ff ff       	call   80101c2a <iunlockput>
80105e47:	83 c4 10             	add    $0x10,%esp

  end_op();
80105e4a:	e8 8a d7 ff ff       	call   801035d9 <end_op>

  return 0;
80105e4f:	b8 00 00 00 00       	mov    $0x0,%eax
80105e54:	eb 19                	jmp    80105e6f <sys_unlink+0x1e1>
    goto bad;
80105e56:	90                   	nop

bad:
  iunlockput(dp);
80105e57:	83 ec 0c             	sub    $0xc,%esp
80105e5a:	ff 75 f4             	pushl  -0xc(%ebp)
80105e5d:	e8 c8 bd ff ff       	call   80101c2a <iunlockput>
80105e62:	83 c4 10             	add    $0x10,%esp
  end_op();
80105e65:	e8 6f d7 ff ff       	call   801035d9 <end_op>
  return -1;
80105e6a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e6f:	c9                   	leave  
80105e70:	c3                   	ret    

80105e71 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80105e71:	55                   	push   %ebp
80105e72:	89 e5                	mov    %esp,%ebp
80105e74:	83 ec 38             	sub    $0x38,%esp
80105e77:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105e7a:	8b 55 10             	mov    0x10(%ebp),%edx
80105e7d:	8b 45 14             	mov    0x14(%ebp),%eax
80105e80:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80105e84:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80105e88:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105e8c:	83 ec 08             	sub    $0x8,%esp
80105e8f:	8d 45 de             	lea    -0x22(%ebp),%eax
80105e92:	50                   	push   %eax
80105e93:	ff 75 08             	pushl  0x8(%ebp)
80105e96:	e8 a9 c6 ff ff       	call   80102544 <nameiparent>
80105e9b:	83 c4 10             	add    $0x10,%esp
80105e9e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105ea1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105ea5:	75 0a                	jne    80105eb1 <create+0x40>
    return 0;
80105ea7:	b8 00 00 00 00       	mov    $0x0,%eax
80105eac:	e9 90 01 00 00       	jmp    80106041 <create+0x1d0>
  ilock(dp);
80105eb1:	83 ec 0c             	sub    $0xc,%esp
80105eb4:	ff 75 f4             	pushl  -0xc(%ebp)
80105eb7:	e8 ae ba ff ff       	call   8010196a <ilock>
80105ebc:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, &off)) != 0){
80105ebf:	83 ec 04             	sub    $0x4,%esp
80105ec2:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105ec5:	50                   	push   %eax
80105ec6:	8d 45 de             	lea    -0x22(%ebp),%eax
80105ec9:	50                   	push   %eax
80105eca:	ff 75 f4             	pushl  -0xc(%ebp)
80105ecd:	e8 00 c3 ff ff       	call   801021d2 <dirlookup>
80105ed2:	83 c4 10             	add    $0x10,%esp
80105ed5:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105ed8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105edc:	74 50                	je     80105f2e <create+0xbd>
    iunlockput(dp);
80105ede:	83 ec 0c             	sub    $0xc,%esp
80105ee1:	ff 75 f4             	pushl  -0xc(%ebp)
80105ee4:	e8 41 bd ff ff       	call   80101c2a <iunlockput>
80105ee9:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
80105eec:	83 ec 0c             	sub    $0xc,%esp
80105eef:	ff 75 f0             	pushl  -0x10(%ebp)
80105ef2:	e8 73 ba ff ff       	call   8010196a <ilock>
80105ef7:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
80105efa:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105eff:	75 15                	jne    80105f16 <create+0xa5>
80105f01:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f04:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105f08:	66 83 f8 02          	cmp    $0x2,%ax
80105f0c:	75 08                	jne    80105f16 <create+0xa5>
      return ip;
80105f0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f11:	e9 2b 01 00 00       	jmp    80106041 <create+0x1d0>
    iunlockput(ip);
80105f16:	83 ec 0c             	sub    $0xc,%esp
80105f19:	ff 75 f0             	pushl  -0x10(%ebp)
80105f1c:	e8 09 bd ff ff       	call   80101c2a <iunlockput>
80105f21:	83 c4 10             	add    $0x10,%esp
    return 0;
80105f24:	b8 00 00 00 00       	mov    $0x0,%eax
80105f29:	e9 13 01 00 00       	jmp    80106041 <create+0x1d0>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80105f2e:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80105f32:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f35:	8b 00                	mov    (%eax),%eax
80105f37:	83 ec 08             	sub    $0x8,%esp
80105f3a:	52                   	push   %edx
80105f3b:	50                   	push   %eax
80105f3c:	e8 78 b7 ff ff       	call   801016b9 <ialloc>
80105f41:	83 c4 10             	add    $0x10,%esp
80105f44:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105f47:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105f4b:	75 0d                	jne    80105f5a <create+0xe9>
    panic("create: ialloc");
80105f4d:	83 ec 0c             	sub    $0xc,%esp
80105f50:	68 58 8b 10 80       	push   $0x80108b58
80105f55:	e8 0c a6 ff ff       	call   80100566 <panic>

  ilock(ip);
80105f5a:	83 ec 0c             	sub    $0xc,%esp
80105f5d:	ff 75 f0             	pushl  -0x10(%ebp)
80105f60:	e8 05 ba ff ff       	call   8010196a <ilock>
80105f65:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
80105f68:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f6b:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
80105f6f:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
80105f73:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f76:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80105f7a:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
80105f7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f81:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
80105f87:	83 ec 0c             	sub    $0xc,%esp
80105f8a:	ff 75 f0             	pushl  -0x10(%ebp)
80105f8d:	e8 fe b7 ff ff       	call   80101790 <iupdate>
80105f92:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
80105f95:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105f9a:	75 6a                	jne    80106006 <create+0x195>
    dp->nlink++;  // for ".."
80105f9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f9f:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105fa3:	83 c0 01             	add    $0x1,%eax
80105fa6:	89 c2                	mov    %eax,%edx
80105fa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fab:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80105faf:	83 ec 0c             	sub    $0xc,%esp
80105fb2:	ff 75 f4             	pushl  -0xc(%ebp)
80105fb5:	e8 d6 b7 ff ff       	call   80101790 <iupdate>
80105fba:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105fbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fc0:	8b 40 04             	mov    0x4(%eax),%eax
80105fc3:	83 ec 04             	sub    $0x4,%esp
80105fc6:	50                   	push   %eax
80105fc7:	68 32 8b 10 80       	push   $0x80108b32
80105fcc:	ff 75 f0             	pushl  -0x10(%ebp)
80105fcf:	e8 b8 c2 ff ff       	call   8010228c <dirlink>
80105fd4:	83 c4 10             	add    $0x10,%esp
80105fd7:	85 c0                	test   %eax,%eax
80105fd9:	78 1e                	js     80105ff9 <create+0x188>
80105fdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fde:	8b 40 04             	mov    0x4(%eax),%eax
80105fe1:	83 ec 04             	sub    $0x4,%esp
80105fe4:	50                   	push   %eax
80105fe5:	68 34 8b 10 80       	push   $0x80108b34
80105fea:	ff 75 f0             	pushl  -0x10(%ebp)
80105fed:	e8 9a c2 ff ff       	call   8010228c <dirlink>
80105ff2:	83 c4 10             	add    $0x10,%esp
80105ff5:	85 c0                	test   %eax,%eax
80105ff7:	79 0d                	jns    80106006 <create+0x195>
      panic("create dots");
80105ff9:	83 ec 0c             	sub    $0xc,%esp
80105ffc:	68 67 8b 10 80       	push   $0x80108b67
80106001:	e8 60 a5 ff ff       	call   80100566 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80106006:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106009:	8b 40 04             	mov    0x4(%eax),%eax
8010600c:	83 ec 04             	sub    $0x4,%esp
8010600f:	50                   	push   %eax
80106010:	8d 45 de             	lea    -0x22(%ebp),%eax
80106013:	50                   	push   %eax
80106014:	ff 75 f4             	pushl  -0xc(%ebp)
80106017:	e8 70 c2 ff ff       	call   8010228c <dirlink>
8010601c:	83 c4 10             	add    $0x10,%esp
8010601f:	85 c0                	test   %eax,%eax
80106021:	79 0d                	jns    80106030 <create+0x1bf>
    panic("create: dirlink");
80106023:	83 ec 0c             	sub    $0xc,%esp
80106026:	68 73 8b 10 80       	push   $0x80108b73
8010602b:	e8 36 a5 ff ff       	call   80100566 <panic>

  iunlockput(dp);
80106030:	83 ec 0c             	sub    $0xc,%esp
80106033:	ff 75 f4             	pushl  -0xc(%ebp)
80106036:	e8 ef bb ff ff       	call   80101c2a <iunlockput>
8010603b:	83 c4 10             	add    $0x10,%esp

  return ip;
8010603e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80106041:	c9                   	leave  
80106042:	c3                   	ret    

80106043 <sys_open>:

int
sys_open(void)
{
80106043:	55                   	push   %ebp
80106044:	89 e5                	mov    %esp,%ebp
80106046:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80106049:	83 ec 08             	sub    $0x8,%esp
8010604c:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010604f:	50                   	push   %eax
80106050:	6a 00                	push   $0x0
80106052:	e8 eb f6 ff ff       	call   80105742 <argstr>
80106057:	83 c4 10             	add    $0x10,%esp
8010605a:	85 c0                	test   %eax,%eax
8010605c:	78 15                	js     80106073 <sys_open+0x30>
8010605e:	83 ec 08             	sub    $0x8,%esp
80106061:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106064:	50                   	push   %eax
80106065:	6a 01                	push   $0x1
80106067:	e8 51 f6 ff ff       	call   801056bd <argint>
8010606c:	83 c4 10             	add    $0x10,%esp
8010606f:	85 c0                	test   %eax,%eax
80106071:	79 0a                	jns    8010607d <sys_open+0x3a>
    return -1;
80106073:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106078:	e9 61 01 00 00       	jmp    801061de <sys_open+0x19b>

  begin_op();
8010607d:	e8 cb d4 ff ff       	call   8010354d <begin_op>

  if(omode & O_CREATE){
80106082:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106085:	25 00 02 00 00       	and    $0x200,%eax
8010608a:	85 c0                	test   %eax,%eax
8010608c:	74 2a                	je     801060b8 <sys_open+0x75>
    ip = create(path, T_FILE, 0, 0);
8010608e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106091:	6a 00                	push   $0x0
80106093:	6a 00                	push   $0x0
80106095:	6a 02                	push   $0x2
80106097:	50                   	push   %eax
80106098:	e8 d4 fd ff ff       	call   80105e71 <create>
8010609d:	83 c4 10             	add    $0x10,%esp
801060a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
801060a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801060a7:	75 75                	jne    8010611e <sys_open+0xdb>
      end_op();
801060a9:	e8 2b d5 ff ff       	call   801035d9 <end_op>
      return -1;
801060ae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060b3:	e9 26 01 00 00       	jmp    801061de <sys_open+0x19b>
    }
  } else {
    if((ip = namei(path)) == 0){
801060b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
801060bb:	83 ec 0c             	sub    $0xc,%esp
801060be:	50                   	push   %eax
801060bf:	e8 64 c4 ff ff       	call   80102528 <namei>
801060c4:	83 c4 10             	add    $0x10,%esp
801060c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
801060ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801060ce:	75 0f                	jne    801060df <sys_open+0x9c>
      end_op();
801060d0:	e8 04 d5 ff ff       	call   801035d9 <end_op>
      return -1;
801060d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060da:	e9 ff 00 00 00       	jmp    801061de <sys_open+0x19b>
    }
    ilock(ip);
801060df:	83 ec 0c             	sub    $0xc,%esp
801060e2:	ff 75 f4             	pushl  -0xc(%ebp)
801060e5:	e8 80 b8 ff ff       	call   8010196a <ilock>
801060ea:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
801060ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060f0:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801060f4:	66 83 f8 01          	cmp    $0x1,%ax
801060f8:	75 24                	jne    8010611e <sys_open+0xdb>
801060fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801060fd:	85 c0                	test   %eax,%eax
801060ff:	74 1d                	je     8010611e <sys_open+0xdb>
      iunlockput(ip);
80106101:	83 ec 0c             	sub    $0xc,%esp
80106104:	ff 75 f4             	pushl  -0xc(%ebp)
80106107:	e8 1e bb ff ff       	call   80101c2a <iunlockput>
8010610c:	83 c4 10             	add    $0x10,%esp
      end_op();
8010610f:	e8 c5 d4 ff ff       	call   801035d9 <end_op>
      return -1;
80106114:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106119:	e9 c0 00 00 00       	jmp    801061de <sys_open+0x19b>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010611e:	e8 70 ae ff ff       	call   80100f93 <filealloc>
80106123:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106126:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010612a:	74 17                	je     80106143 <sys_open+0x100>
8010612c:	83 ec 0c             	sub    $0xc,%esp
8010612f:	ff 75 f0             	pushl  -0x10(%ebp)
80106132:	e8 37 f7 ff ff       	call   8010586e <fdalloc>
80106137:	83 c4 10             	add    $0x10,%esp
8010613a:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010613d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80106141:	79 2e                	jns    80106171 <sys_open+0x12e>
    if(f)
80106143:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106147:	74 0e                	je     80106157 <sys_open+0x114>
      fileclose(f);
80106149:	83 ec 0c             	sub    $0xc,%esp
8010614c:	ff 75 f0             	pushl  -0x10(%ebp)
8010614f:	e8 fd ae ff ff       	call   80101051 <fileclose>
80106154:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80106157:	83 ec 0c             	sub    $0xc,%esp
8010615a:	ff 75 f4             	pushl  -0xc(%ebp)
8010615d:	e8 c8 ba ff ff       	call   80101c2a <iunlockput>
80106162:	83 c4 10             	add    $0x10,%esp
    end_op();
80106165:	e8 6f d4 ff ff       	call   801035d9 <end_op>
    return -1;
8010616a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010616f:	eb 6d                	jmp    801061de <sys_open+0x19b>
  }
  iunlock(ip);
80106171:	83 ec 0c             	sub    $0xc,%esp
80106174:	ff 75 f4             	pushl  -0xc(%ebp)
80106177:	e8 4c b9 ff ff       	call   80101ac8 <iunlock>
8010617c:	83 c4 10             	add    $0x10,%esp
  end_op();
8010617f:	e8 55 d4 ff ff       	call   801035d9 <end_op>

  f->type = FD_INODE;
80106184:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106187:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
8010618d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106190:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106193:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80106196:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106199:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
801061a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801061a3:	83 e0 01             	and    $0x1,%eax
801061a6:	85 c0                	test   %eax,%eax
801061a8:	0f 94 c0             	sete   %al
801061ab:	89 c2                	mov    %eax,%edx
801061ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061b0:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801061b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801061b6:	83 e0 01             	and    $0x1,%eax
801061b9:	85 c0                	test   %eax,%eax
801061bb:	75 0a                	jne    801061c7 <sys_open+0x184>
801061bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801061c0:	83 e0 02             	and    $0x2,%eax
801061c3:	85 c0                	test   %eax,%eax
801061c5:	74 07                	je     801061ce <sys_open+0x18b>
801061c7:	b8 01 00 00 00       	mov    $0x1,%eax
801061cc:	eb 05                	jmp    801061d3 <sys_open+0x190>
801061ce:	b8 00 00 00 00       	mov    $0x0,%eax
801061d3:	89 c2                	mov    %eax,%edx
801061d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061d8:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
801061db:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
801061de:	c9                   	leave  
801061df:	c3                   	ret    

801061e0 <sys_mkdir>:

int
sys_mkdir(void)
{
801061e0:	55                   	push   %ebp
801061e1:	89 e5                	mov    %esp,%ebp
801061e3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801061e6:	e8 62 d3 ff ff       	call   8010354d <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801061eb:	83 ec 08             	sub    $0x8,%esp
801061ee:	8d 45 f0             	lea    -0x10(%ebp),%eax
801061f1:	50                   	push   %eax
801061f2:	6a 00                	push   $0x0
801061f4:	e8 49 f5 ff ff       	call   80105742 <argstr>
801061f9:	83 c4 10             	add    $0x10,%esp
801061fc:	85 c0                	test   %eax,%eax
801061fe:	78 1b                	js     8010621b <sys_mkdir+0x3b>
80106200:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106203:	6a 00                	push   $0x0
80106205:	6a 00                	push   $0x0
80106207:	6a 01                	push   $0x1
80106209:	50                   	push   %eax
8010620a:	e8 62 fc ff ff       	call   80105e71 <create>
8010620f:	83 c4 10             	add    $0x10,%esp
80106212:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106215:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106219:	75 0c                	jne    80106227 <sys_mkdir+0x47>
    end_op();
8010621b:	e8 b9 d3 ff ff       	call   801035d9 <end_op>
    return -1;
80106220:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106225:	eb 18                	jmp    8010623f <sys_mkdir+0x5f>
  }
  iunlockput(ip);
80106227:	83 ec 0c             	sub    $0xc,%esp
8010622a:	ff 75 f4             	pushl  -0xc(%ebp)
8010622d:	e8 f8 b9 ff ff       	call   80101c2a <iunlockput>
80106232:	83 c4 10             	add    $0x10,%esp
  end_op();
80106235:	e8 9f d3 ff ff       	call   801035d9 <end_op>
  return 0;
8010623a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010623f:	c9                   	leave  
80106240:	c3                   	ret    

80106241 <sys_mknod>:

int
sys_mknod(void)
{
80106241:	55                   	push   %ebp
80106242:	89 e5                	mov    %esp,%ebp
80106244:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_op();
80106247:	e8 01 d3 ff ff       	call   8010354d <begin_op>
  if((len=argstr(0, &path)) < 0 ||
8010624c:	83 ec 08             	sub    $0x8,%esp
8010624f:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106252:	50                   	push   %eax
80106253:	6a 00                	push   $0x0
80106255:	e8 e8 f4 ff ff       	call   80105742 <argstr>
8010625a:	83 c4 10             	add    $0x10,%esp
8010625d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106260:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106264:	78 4f                	js     801062b5 <sys_mknod+0x74>
     argint(1, &major) < 0 ||
80106266:	83 ec 08             	sub    $0x8,%esp
80106269:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010626c:	50                   	push   %eax
8010626d:	6a 01                	push   $0x1
8010626f:	e8 49 f4 ff ff       	call   801056bd <argint>
80106274:	83 c4 10             	add    $0x10,%esp
  if((len=argstr(0, &path)) < 0 ||
80106277:	85 c0                	test   %eax,%eax
80106279:	78 3a                	js     801062b5 <sys_mknod+0x74>
     argint(2, &minor) < 0 ||
8010627b:	83 ec 08             	sub    $0x8,%esp
8010627e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106281:	50                   	push   %eax
80106282:	6a 02                	push   $0x2
80106284:	e8 34 f4 ff ff       	call   801056bd <argint>
80106289:	83 c4 10             	add    $0x10,%esp
     argint(1, &major) < 0 ||
8010628c:	85 c0                	test   %eax,%eax
8010628e:	78 25                	js     801062b5 <sys_mknod+0x74>
     (ip = create(path, T_DEV, major, minor)) == 0){
80106290:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106293:	0f bf c8             	movswl %ax,%ecx
80106296:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106299:	0f bf d0             	movswl %ax,%edx
8010629c:	8b 45 ec             	mov    -0x14(%ebp),%eax
     argint(2, &minor) < 0 ||
8010629f:	51                   	push   %ecx
801062a0:	52                   	push   %edx
801062a1:	6a 03                	push   $0x3
801062a3:	50                   	push   %eax
801062a4:	e8 c8 fb ff ff       	call   80105e71 <create>
801062a9:	83 c4 10             	add    $0x10,%esp
801062ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
801062af:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801062b3:	75 0c                	jne    801062c1 <sys_mknod+0x80>
    end_op();
801062b5:	e8 1f d3 ff ff       	call   801035d9 <end_op>
    return -1;
801062ba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062bf:	eb 18                	jmp    801062d9 <sys_mknod+0x98>
  }
  iunlockput(ip);
801062c1:	83 ec 0c             	sub    $0xc,%esp
801062c4:	ff 75 f0             	pushl  -0x10(%ebp)
801062c7:	e8 5e b9 ff ff       	call   80101c2a <iunlockput>
801062cc:	83 c4 10             	add    $0x10,%esp
  end_op();
801062cf:	e8 05 d3 ff ff       	call   801035d9 <end_op>
  return 0;
801062d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
801062d9:	c9                   	leave  
801062da:	c3                   	ret    

801062db <sys_chdir>:

int
sys_chdir(void)
{
801062db:	55                   	push   %ebp
801062dc:	89 e5                	mov    %esp,%ebp
801062de:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801062e1:	e8 67 d2 ff ff       	call   8010354d <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801062e6:	83 ec 08             	sub    $0x8,%esp
801062e9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801062ec:	50                   	push   %eax
801062ed:	6a 00                	push   $0x0
801062ef:	e8 4e f4 ff ff       	call   80105742 <argstr>
801062f4:	83 c4 10             	add    $0x10,%esp
801062f7:	85 c0                	test   %eax,%eax
801062f9:	78 18                	js     80106313 <sys_chdir+0x38>
801062fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062fe:	83 ec 0c             	sub    $0xc,%esp
80106301:	50                   	push   %eax
80106302:	e8 21 c2 ff ff       	call   80102528 <namei>
80106307:	83 c4 10             	add    $0x10,%esp
8010630a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010630d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106311:	75 0c                	jne    8010631f <sys_chdir+0x44>
    end_op();
80106313:	e8 c1 d2 ff ff       	call   801035d9 <end_op>
    return -1;
80106318:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010631d:	eb 6e                	jmp    8010638d <sys_chdir+0xb2>
  }
  ilock(ip);
8010631f:	83 ec 0c             	sub    $0xc,%esp
80106322:	ff 75 f4             	pushl  -0xc(%ebp)
80106325:	e8 40 b6 ff ff       	call   8010196a <ilock>
8010632a:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
8010632d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106330:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106334:	66 83 f8 01          	cmp    $0x1,%ax
80106338:	74 1a                	je     80106354 <sys_chdir+0x79>
    iunlockput(ip);
8010633a:	83 ec 0c             	sub    $0xc,%esp
8010633d:	ff 75 f4             	pushl  -0xc(%ebp)
80106340:	e8 e5 b8 ff ff       	call   80101c2a <iunlockput>
80106345:	83 c4 10             	add    $0x10,%esp
    end_op();
80106348:	e8 8c d2 ff ff       	call   801035d9 <end_op>
    return -1;
8010634d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106352:	eb 39                	jmp    8010638d <sys_chdir+0xb2>
  }
  iunlock(ip);
80106354:	83 ec 0c             	sub    $0xc,%esp
80106357:	ff 75 f4             	pushl  -0xc(%ebp)
8010635a:	e8 69 b7 ff ff       	call   80101ac8 <iunlock>
8010635f:	83 c4 10             	add    $0x10,%esp
  iput(proc->cwd);
80106362:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106368:	8b 40 68             	mov    0x68(%eax),%eax
8010636b:	83 ec 0c             	sub    $0xc,%esp
8010636e:	50                   	push   %eax
8010636f:	e8 c6 b7 ff ff       	call   80101b3a <iput>
80106374:	83 c4 10             	add    $0x10,%esp
  end_op();
80106377:	e8 5d d2 ff ff       	call   801035d9 <end_op>
  proc->cwd = ip;
8010637c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106382:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106385:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80106388:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010638d:	c9                   	leave  
8010638e:	c3                   	ret    

8010638f <sys_exec>:

int
sys_exec(void)
{
8010638f:	55                   	push   %ebp
80106390:	89 e5                	mov    %esp,%ebp
80106392:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106398:	83 ec 08             	sub    $0x8,%esp
8010639b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010639e:	50                   	push   %eax
8010639f:	6a 00                	push   $0x0
801063a1:	e8 9c f3 ff ff       	call   80105742 <argstr>
801063a6:	83 c4 10             	add    $0x10,%esp
801063a9:	85 c0                	test   %eax,%eax
801063ab:	78 18                	js     801063c5 <sys_exec+0x36>
801063ad:	83 ec 08             	sub    $0x8,%esp
801063b0:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
801063b6:	50                   	push   %eax
801063b7:	6a 01                	push   $0x1
801063b9:	e8 ff f2 ff ff       	call   801056bd <argint>
801063be:	83 c4 10             	add    $0x10,%esp
801063c1:	85 c0                	test   %eax,%eax
801063c3:	79 0a                	jns    801063cf <sys_exec+0x40>
    return -1;
801063c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063ca:	e9 c6 00 00 00       	jmp    80106495 <sys_exec+0x106>
  }
  memset(argv, 0, sizeof(argv));
801063cf:	83 ec 04             	sub    $0x4,%esp
801063d2:	68 80 00 00 00       	push   $0x80
801063d7:	6a 00                	push   $0x0
801063d9:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
801063df:	50                   	push   %eax
801063e0:	e8 b3 ef ff ff       	call   80105398 <memset>
801063e5:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
801063e8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
801063ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063f2:	83 f8 1f             	cmp    $0x1f,%eax
801063f5:	76 0a                	jbe    80106401 <sys_exec+0x72>
      return -1;
801063f7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063fc:	e9 94 00 00 00       	jmp    80106495 <sys_exec+0x106>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80106401:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106404:	c1 e0 02             	shl    $0x2,%eax
80106407:	89 c2                	mov    %eax,%edx
80106409:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
8010640f:	01 c2                	add    %eax,%edx
80106411:	83 ec 08             	sub    $0x8,%esp
80106414:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
8010641a:	50                   	push   %eax
8010641b:	52                   	push   %edx
8010641c:	e8 00 f2 ff ff       	call   80105621 <fetchint>
80106421:	83 c4 10             	add    $0x10,%esp
80106424:	85 c0                	test   %eax,%eax
80106426:	79 07                	jns    8010642f <sys_exec+0xa0>
      return -1;
80106428:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010642d:	eb 66                	jmp    80106495 <sys_exec+0x106>
    if(uarg == 0){
8010642f:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106435:	85 c0                	test   %eax,%eax
80106437:	75 27                	jne    80106460 <sys_exec+0xd1>
      argv[i] = 0;
80106439:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010643c:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80106443:	00 00 00 00 
      break;
80106447:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80106448:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010644b:	83 ec 08             	sub    $0x8,%esp
8010644e:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80106454:	52                   	push   %edx
80106455:	50                   	push   %eax
80106456:	e8 16 a7 ff ff       	call   80100b71 <exec>
8010645b:	83 c4 10             	add    $0x10,%esp
8010645e:	eb 35                	jmp    80106495 <sys_exec+0x106>
    if(fetchstr(uarg, &argv[i]) < 0)
80106460:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106466:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106469:	c1 e2 02             	shl    $0x2,%edx
8010646c:	01 c2                	add    %eax,%edx
8010646e:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106474:	83 ec 08             	sub    $0x8,%esp
80106477:	52                   	push   %edx
80106478:	50                   	push   %eax
80106479:	e8 dd f1 ff ff       	call   8010565b <fetchstr>
8010647e:	83 c4 10             	add    $0x10,%esp
80106481:	85 c0                	test   %eax,%eax
80106483:	79 07                	jns    8010648c <sys_exec+0xfd>
      return -1;
80106485:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010648a:	eb 09                	jmp    80106495 <sys_exec+0x106>
  for(i=0;; i++){
8010648c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(i >= NELEM(argv))
80106490:	e9 5a ff ff ff       	jmp    801063ef <sys_exec+0x60>
}
80106495:	c9                   	leave  
80106496:	c3                   	ret    

80106497 <sys_pipe>:

int
sys_pipe(void)
{
80106497:	55                   	push   %ebp
80106498:	89 e5                	mov    %esp,%ebp
8010649a:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010649d:	83 ec 04             	sub    $0x4,%esp
801064a0:	6a 08                	push   $0x8
801064a2:	8d 45 ec             	lea    -0x14(%ebp),%eax
801064a5:	50                   	push   %eax
801064a6:	6a 00                	push   $0x0
801064a8:	e8 38 f2 ff ff       	call   801056e5 <argptr>
801064ad:	83 c4 10             	add    $0x10,%esp
801064b0:	85 c0                	test   %eax,%eax
801064b2:	79 0a                	jns    801064be <sys_pipe+0x27>
    return -1;
801064b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064b9:	e9 af 00 00 00       	jmp    8010656d <sys_pipe+0xd6>
  if(pipealloc(&rf, &wf) < 0)
801064be:	83 ec 08             	sub    $0x8,%esp
801064c1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801064c4:	50                   	push   %eax
801064c5:	8d 45 e8             	lea    -0x18(%ebp),%eax
801064c8:	50                   	push   %eax
801064c9:	e8 73 db ff ff       	call   80104041 <pipealloc>
801064ce:	83 c4 10             	add    $0x10,%esp
801064d1:	85 c0                	test   %eax,%eax
801064d3:	79 0a                	jns    801064df <sys_pipe+0x48>
    return -1;
801064d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064da:	e9 8e 00 00 00       	jmp    8010656d <sys_pipe+0xd6>
  fd0 = -1;
801064df:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801064e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
801064e9:	83 ec 0c             	sub    $0xc,%esp
801064ec:	50                   	push   %eax
801064ed:	e8 7c f3 ff ff       	call   8010586e <fdalloc>
801064f2:	83 c4 10             	add    $0x10,%esp
801064f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
801064f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801064fc:	78 18                	js     80106516 <sys_pipe+0x7f>
801064fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106501:	83 ec 0c             	sub    $0xc,%esp
80106504:	50                   	push   %eax
80106505:	e8 64 f3 ff ff       	call   8010586e <fdalloc>
8010650a:	83 c4 10             	add    $0x10,%esp
8010650d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106510:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106514:	79 3f                	jns    80106555 <sys_pipe+0xbe>
    if(fd0 >= 0)
80106516:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010651a:	78 14                	js     80106530 <sys_pipe+0x99>
      proc->ofile[fd0] = 0;
8010651c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106522:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106525:	83 c2 08             	add    $0x8,%edx
80106528:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
8010652f:	00 
    fileclose(rf);
80106530:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106533:	83 ec 0c             	sub    $0xc,%esp
80106536:	50                   	push   %eax
80106537:	e8 15 ab ff ff       	call   80101051 <fileclose>
8010653c:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
8010653f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106542:	83 ec 0c             	sub    $0xc,%esp
80106545:	50                   	push   %eax
80106546:	e8 06 ab ff ff       	call   80101051 <fileclose>
8010654b:	83 c4 10             	add    $0x10,%esp
    return -1;
8010654e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106553:	eb 18                	jmp    8010656d <sys_pipe+0xd6>
  }
  fd[0] = fd0;
80106555:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106558:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010655b:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
8010655d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106560:	8d 50 04             	lea    0x4(%eax),%edx
80106563:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106566:	89 02                	mov    %eax,(%edx)
  return 0;
80106568:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010656d:	c9                   	leave  
8010656e:	c3                   	ret    

8010656f <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
8010656f:	55                   	push   %ebp
80106570:	89 e5                	mov    %esp,%ebp
80106572:	83 ec 18             	sub    $0x18,%esp
  int argtickets;
  argint(0,&argtickets);
80106575:	83 ec 08             	sub    $0x8,%esp
80106578:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010657b:	50                   	push   %eax
8010657c:	6a 00                	push   $0x0
8010657e:	e8 3a f1 ff ff       	call   801056bd <argint>
80106583:	83 c4 10             	add    $0x10,%esp
  return fork(argtickets);
80106586:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106589:	83 ec 0c             	sub    $0xc,%esp
8010658c:	50                   	push   %eax
8010658d:	e8 9f e1 ff ff       	call   80104731 <fork>
80106592:	83 c4 10             	add    $0x10,%esp
}
80106595:	c9                   	leave  
80106596:	c3                   	ret    

80106597 <sys_exit>:

int
sys_exit(void)
{
80106597:	55                   	push   %ebp
80106598:	89 e5                	mov    %esp,%ebp
8010659a:	83 ec 08             	sub    $0x8,%esp
  exit();
8010659d:	e8 a3 e3 ff ff       	call   80104945 <exit>
  return 0;  // not reached
801065a2:	b8 00 00 00 00       	mov    $0x0,%eax
}
801065a7:	c9                   	leave  
801065a8:	c3                   	ret    

801065a9 <sys_wait>:

int
sys_wait(void)
{
801065a9:	55                   	push   %ebp
801065aa:	89 e5                	mov    %esp,%ebp
801065ac:	83 ec 08             	sub    $0x8,%esp
  return wait();
801065af:	e8 c9 e4 ff ff       	call   80104a7d <wait>
}
801065b4:	c9                   	leave  
801065b5:	c3                   	ret    

801065b6 <sys_kill>:

int
sys_kill(void)
{
801065b6:	55                   	push   %ebp
801065b7:	89 e5                	mov    %esp,%ebp
801065b9:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
801065bc:	83 ec 08             	sub    $0x8,%esp
801065bf:	8d 45 f4             	lea    -0xc(%ebp),%eax
801065c2:	50                   	push   %eax
801065c3:	6a 00                	push   $0x0
801065c5:	e8 f3 f0 ff ff       	call   801056bd <argint>
801065ca:	83 c4 10             	add    $0x10,%esp
801065cd:	85 c0                	test   %eax,%eax
801065cf:	79 07                	jns    801065d8 <sys_kill+0x22>
    return -1;
801065d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065d6:	eb 0f                	jmp    801065e7 <sys_kill+0x31>
  return kill(pid);
801065d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065db:	83 ec 0c             	sub    $0xc,%esp
801065de:	50                   	push   %eax
801065df:	e8 88 e9 ff ff       	call   80104f6c <kill>
801065e4:	83 c4 10             	add    $0x10,%esp
}
801065e7:	c9                   	leave  
801065e8:	c3                   	ret    

801065e9 <sys_getpid>:

int
sys_getpid(void)
{
801065e9:	55                   	push   %ebp
801065ea:	89 e5                	mov    %esp,%ebp
  return proc->pid;
801065ec:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801065f2:	8b 40 10             	mov    0x10(%eax),%eax
}
801065f5:	5d                   	pop    %ebp
801065f6:	c3                   	ret    

801065f7 <sys_sbrk>:

int
sys_sbrk(void)
{
801065f7:	55                   	push   %ebp
801065f8:	89 e5                	mov    %esp,%ebp
801065fa:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
801065fd:	83 ec 08             	sub    $0x8,%esp
80106600:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106603:	50                   	push   %eax
80106604:	6a 00                	push   $0x0
80106606:	e8 b2 f0 ff ff       	call   801056bd <argint>
8010660b:	83 c4 10             	add    $0x10,%esp
8010660e:	85 c0                	test   %eax,%eax
80106610:	79 07                	jns    80106619 <sys_sbrk+0x22>
    return -1;
80106612:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106617:	eb 28                	jmp    80106641 <sys_sbrk+0x4a>
  addr = proc->sz;
80106619:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010661f:	8b 00                	mov    (%eax),%eax
80106621:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80106624:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106627:	83 ec 0c             	sub    $0xc,%esp
8010662a:	50                   	push   %eax
8010662b:	e8 5e e0 ff ff       	call   8010468e <growproc>
80106630:	83 c4 10             	add    $0x10,%esp
80106633:	85 c0                	test   %eax,%eax
80106635:	79 07                	jns    8010663e <sys_sbrk+0x47>
    return -1;
80106637:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010663c:	eb 03                	jmp    80106641 <sys_sbrk+0x4a>
  return addr;
8010663e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106641:	c9                   	leave  
80106642:	c3                   	ret    

80106643 <sys_sleep>:

int
sys_sleep(void)
{
80106643:	55                   	push   %ebp
80106644:	89 e5                	mov    %esp,%ebp
80106646:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
80106649:	83 ec 08             	sub    $0x8,%esp
8010664c:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010664f:	50                   	push   %eax
80106650:	6a 00                	push   $0x0
80106652:	e8 66 f0 ff ff       	call   801056bd <argint>
80106657:	83 c4 10             	add    $0x10,%esp
8010665a:	85 c0                	test   %eax,%eax
8010665c:	79 07                	jns    80106665 <sys_sleep+0x22>
    return -1;
8010665e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106663:	eb 77                	jmp    801066dc <sys_sleep+0x99>
  acquire(&tickslock);
80106665:	83 ec 0c             	sub    $0xc,%esp
80106668:	68 a0 49 11 80       	push   $0x801149a0
8010666d:	e8 c3 ea ff ff       	call   80105135 <acquire>
80106672:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80106675:	a1 e0 51 11 80       	mov    0x801151e0,%eax
8010667a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
8010667d:	eb 39                	jmp    801066b8 <sys_sleep+0x75>
    if(proc->killed){
8010667f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106685:	8b 40 24             	mov    0x24(%eax),%eax
80106688:	85 c0                	test   %eax,%eax
8010668a:	74 17                	je     801066a3 <sys_sleep+0x60>
      release(&tickslock);
8010668c:	83 ec 0c             	sub    $0xc,%esp
8010668f:	68 a0 49 11 80       	push   $0x801149a0
80106694:	e8 03 eb ff ff       	call   8010519c <release>
80106699:	83 c4 10             	add    $0x10,%esp
      return -1;
8010669c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066a1:	eb 39                	jmp    801066dc <sys_sleep+0x99>
    }
    sleep(&ticks, &tickslock);
801066a3:	83 ec 08             	sub    $0x8,%esp
801066a6:	68 a0 49 11 80       	push   $0x801149a0
801066ab:	68 e0 51 11 80       	push   $0x801151e0
801066b0:	e8 95 e7 ff ff       	call   80104e4a <sleep>
801066b5:	83 c4 10             	add    $0x10,%esp
  while(ticks - ticks0 < n){
801066b8:	a1 e0 51 11 80       	mov    0x801151e0,%eax
801066bd:	2b 45 f4             	sub    -0xc(%ebp),%eax
801066c0:	8b 55 f0             	mov    -0x10(%ebp),%edx
801066c3:	39 d0                	cmp    %edx,%eax
801066c5:	72 b8                	jb     8010667f <sys_sleep+0x3c>
  }
  release(&tickslock);
801066c7:	83 ec 0c             	sub    $0xc,%esp
801066ca:	68 a0 49 11 80       	push   $0x801149a0
801066cf:	e8 c8 ea ff ff       	call   8010519c <release>
801066d4:	83 c4 10             	add    $0x10,%esp
  return 0;
801066d7:	b8 00 00 00 00       	mov    $0x0,%eax
}
801066dc:	c9                   	leave  
801066dd:	c3                   	ret    

801066de <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801066de:	55                   	push   %ebp
801066df:	89 e5                	mov    %esp,%ebp
801066e1:	83 ec 18             	sub    $0x18,%esp
  uint xticks;
  
  acquire(&tickslock);
801066e4:	83 ec 0c             	sub    $0xc,%esp
801066e7:	68 a0 49 11 80       	push   $0x801149a0
801066ec:	e8 44 ea ff ff       	call   80105135 <acquire>
801066f1:	83 c4 10             	add    $0x10,%esp
  xticks = ticks;
801066f4:	a1 e0 51 11 80       	mov    0x801151e0,%eax
801066f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
801066fc:	83 ec 0c             	sub    $0xc,%esp
801066ff:	68 a0 49 11 80       	push   $0x801149a0
80106704:	e8 93 ea ff ff       	call   8010519c <release>
80106709:	83 c4 10             	add    $0x10,%esp
  return xticks;
8010670c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010670f:	c9                   	leave  
80106710:	c3                   	ret    

80106711 <outb>:
{
80106711:	55                   	push   %ebp
80106712:	89 e5                	mov    %esp,%ebp
80106714:	83 ec 08             	sub    $0x8,%esp
80106717:	8b 55 08             	mov    0x8(%ebp),%edx
8010671a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010671d:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106721:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106724:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106728:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010672c:	ee                   	out    %al,(%dx)
}
8010672d:	90                   	nop
8010672e:	c9                   	leave  
8010672f:	c3                   	ret    

80106730 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
80106730:	55                   	push   %ebp
80106731:	89 e5                	mov    %esp,%ebp
80106733:	83 ec 08             	sub    $0x8,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
80106736:	6a 34                	push   $0x34
80106738:	6a 43                	push   $0x43
8010673a:	e8 d2 ff ff ff       	call   80106711 <outb>
8010673f:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
80106742:	68 9c 00 00 00       	push   $0x9c
80106747:	6a 40                	push   $0x40
80106749:	e8 c3 ff ff ff       	call   80106711 <outb>
8010674e:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
80106751:	6a 2e                	push   $0x2e
80106753:	6a 40                	push   $0x40
80106755:	e8 b7 ff ff ff       	call   80106711 <outb>
8010675a:	83 c4 08             	add    $0x8,%esp
  picenable(IRQ_TIMER);
8010675d:	83 ec 0c             	sub    $0xc,%esp
80106760:	6a 00                	push   $0x0
80106762:	e8 c4 d7 ff ff       	call   80103f2b <picenable>
80106767:	83 c4 10             	add    $0x10,%esp
}
8010676a:	90                   	nop
8010676b:	c9                   	leave  
8010676c:	c3                   	ret    

8010676d <alltraps>:
8010676d:	1e                   	push   %ds
8010676e:	06                   	push   %es
8010676f:	0f a0                	push   %fs
80106771:	0f a8                	push   %gs
80106773:	60                   	pusha  
80106774:	66 b8 10 00          	mov    $0x10,%ax
80106778:	8e d8                	mov    %eax,%ds
8010677a:	8e c0                	mov    %eax,%es
8010677c:	66 b8 18 00          	mov    $0x18,%ax
80106780:	8e e0                	mov    %eax,%fs
80106782:	8e e8                	mov    %eax,%gs
80106784:	54                   	push   %esp
80106785:	e8 d7 01 00 00       	call   80106961 <trap>
8010678a:	83 c4 04             	add    $0x4,%esp

8010678d <trapret>:
8010678d:	61                   	popa   
8010678e:	0f a9                	pop    %gs
80106790:	0f a1                	pop    %fs
80106792:	07                   	pop    %es
80106793:	1f                   	pop    %ds
80106794:	83 c4 08             	add    $0x8,%esp
80106797:	cf                   	iret   

80106798 <lidt>:
{
80106798:	55                   	push   %ebp
80106799:	89 e5                	mov    %esp,%ebp
8010679b:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
8010679e:	8b 45 0c             	mov    0xc(%ebp),%eax
801067a1:	83 e8 01             	sub    $0x1,%eax
801067a4:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801067a8:	8b 45 08             	mov    0x8(%ebp),%eax
801067ab:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801067af:	8b 45 08             	mov    0x8(%ebp),%eax
801067b2:	c1 e8 10             	shr    $0x10,%eax
801067b5:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801067b9:	8d 45 fa             	lea    -0x6(%ebp),%eax
801067bc:	0f 01 18             	lidtl  (%eax)
}
801067bf:	90                   	nop
801067c0:	c9                   	leave  
801067c1:	c3                   	ret    

801067c2 <rcr2>:

static inline uint
rcr2(void)
{
801067c2:	55                   	push   %ebp
801067c3:	89 e5                	mov    %esp,%ebp
801067c5:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801067c8:	0f 20 d0             	mov    %cr2,%eax
801067cb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
801067ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801067d1:	c9                   	leave  
801067d2:	c3                   	ret    

801067d3 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801067d3:	55                   	push   %ebp
801067d4:	89 e5                	mov    %esp,%ebp
801067d6:	83 ec 18             	sub    $0x18,%esp
  int i;

  for(i = 0; i < 256; i++)
801067d9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801067e0:	e9 c3 00 00 00       	jmp    801068a8 <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801067e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067e8:	8b 04 85 98 b0 10 80 	mov    -0x7fef4f68(,%eax,4),%eax
801067ef:	89 c2                	mov    %eax,%edx
801067f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067f4:	66 89 14 c5 e0 49 11 	mov    %dx,-0x7feeb620(,%eax,8)
801067fb:	80 
801067fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067ff:	66 c7 04 c5 e2 49 11 	movw   $0x8,-0x7feeb61e(,%eax,8)
80106806:	80 08 00 
80106809:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010680c:	0f b6 14 c5 e4 49 11 	movzbl -0x7feeb61c(,%eax,8),%edx
80106813:	80 
80106814:	83 e2 e0             	and    $0xffffffe0,%edx
80106817:	88 14 c5 e4 49 11 80 	mov    %dl,-0x7feeb61c(,%eax,8)
8010681e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106821:	0f b6 14 c5 e4 49 11 	movzbl -0x7feeb61c(,%eax,8),%edx
80106828:	80 
80106829:	83 e2 1f             	and    $0x1f,%edx
8010682c:	88 14 c5 e4 49 11 80 	mov    %dl,-0x7feeb61c(,%eax,8)
80106833:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106836:	0f b6 14 c5 e5 49 11 	movzbl -0x7feeb61b(,%eax,8),%edx
8010683d:	80 
8010683e:	83 e2 f0             	and    $0xfffffff0,%edx
80106841:	83 ca 0e             	or     $0xe,%edx
80106844:	88 14 c5 e5 49 11 80 	mov    %dl,-0x7feeb61b(,%eax,8)
8010684b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010684e:	0f b6 14 c5 e5 49 11 	movzbl -0x7feeb61b(,%eax,8),%edx
80106855:	80 
80106856:	83 e2 ef             	and    $0xffffffef,%edx
80106859:	88 14 c5 e5 49 11 80 	mov    %dl,-0x7feeb61b(,%eax,8)
80106860:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106863:	0f b6 14 c5 e5 49 11 	movzbl -0x7feeb61b(,%eax,8),%edx
8010686a:	80 
8010686b:	83 e2 9f             	and    $0xffffff9f,%edx
8010686e:	88 14 c5 e5 49 11 80 	mov    %dl,-0x7feeb61b(,%eax,8)
80106875:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106878:	0f b6 14 c5 e5 49 11 	movzbl -0x7feeb61b(,%eax,8),%edx
8010687f:	80 
80106880:	83 ca 80             	or     $0xffffff80,%edx
80106883:	88 14 c5 e5 49 11 80 	mov    %dl,-0x7feeb61b(,%eax,8)
8010688a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010688d:	8b 04 85 98 b0 10 80 	mov    -0x7fef4f68(,%eax,4),%eax
80106894:	c1 e8 10             	shr    $0x10,%eax
80106897:	89 c2                	mov    %eax,%edx
80106899:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010689c:	66 89 14 c5 e6 49 11 	mov    %dx,-0x7feeb61a(,%eax,8)
801068a3:	80 
  for(i = 0; i < 256; i++)
801068a4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801068a8:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
801068af:	0f 8e 30 ff ff ff    	jle    801067e5 <tvinit+0x12>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801068b5:	a1 98 b1 10 80       	mov    0x8010b198,%eax
801068ba:	66 a3 e0 4b 11 80    	mov    %ax,0x80114be0
801068c0:	66 c7 05 e2 4b 11 80 	movw   $0x8,0x80114be2
801068c7:	08 00 
801068c9:	0f b6 05 e4 4b 11 80 	movzbl 0x80114be4,%eax
801068d0:	83 e0 e0             	and    $0xffffffe0,%eax
801068d3:	a2 e4 4b 11 80       	mov    %al,0x80114be4
801068d8:	0f b6 05 e4 4b 11 80 	movzbl 0x80114be4,%eax
801068df:	83 e0 1f             	and    $0x1f,%eax
801068e2:	a2 e4 4b 11 80       	mov    %al,0x80114be4
801068e7:	0f b6 05 e5 4b 11 80 	movzbl 0x80114be5,%eax
801068ee:	83 c8 0f             	or     $0xf,%eax
801068f1:	a2 e5 4b 11 80       	mov    %al,0x80114be5
801068f6:	0f b6 05 e5 4b 11 80 	movzbl 0x80114be5,%eax
801068fd:	83 e0 ef             	and    $0xffffffef,%eax
80106900:	a2 e5 4b 11 80       	mov    %al,0x80114be5
80106905:	0f b6 05 e5 4b 11 80 	movzbl 0x80114be5,%eax
8010690c:	83 c8 60             	or     $0x60,%eax
8010690f:	a2 e5 4b 11 80       	mov    %al,0x80114be5
80106914:	0f b6 05 e5 4b 11 80 	movzbl 0x80114be5,%eax
8010691b:	83 c8 80             	or     $0xffffff80,%eax
8010691e:	a2 e5 4b 11 80       	mov    %al,0x80114be5
80106923:	a1 98 b1 10 80       	mov    0x8010b198,%eax
80106928:	c1 e8 10             	shr    $0x10,%eax
8010692b:	66 a3 e6 4b 11 80    	mov    %ax,0x80114be6
  
  initlock(&tickslock, "time");
80106931:	83 ec 08             	sub    $0x8,%esp
80106934:	68 84 8b 10 80       	push   $0x80108b84
80106939:	68 a0 49 11 80       	push   $0x801149a0
8010693e:	e8 d0 e7 ff ff       	call   80105113 <initlock>
80106943:	83 c4 10             	add    $0x10,%esp
}
80106946:	90                   	nop
80106947:	c9                   	leave  
80106948:	c3                   	ret    

80106949 <idtinit>:

void
idtinit(void)
{
80106949:	55                   	push   %ebp
8010694a:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
8010694c:	68 00 08 00 00       	push   $0x800
80106951:	68 e0 49 11 80       	push   $0x801149e0
80106956:	e8 3d fe ff ff       	call   80106798 <lidt>
8010695b:	83 c4 08             	add    $0x8,%esp
}
8010695e:	90                   	nop
8010695f:	c9                   	leave  
80106960:	c3                   	ret    

80106961 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106961:	55                   	push   %ebp
80106962:	89 e5                	mov    %esp,%ebp
80106964:	57                   	push   %edi
80106965:	56                   	push   %esi
80106966:	53                   	push   %ebx
80106967:	83 ec 1c             	sub    $0x1c,%esp
  if(tf->trapno == T_SYSCALL){
8010696a:	8b 45 08             	mov    0x8(%ebp),%eax
8010696d:	8b 40 30             	mov    0x30(%eax),%eax
80106970:	83 f8 40             	cmp    $0x40,%eax
80106973:	75 3e                	jne    801069b3 <trap+0x52>
    if(proc->killed)
80106975:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010697b:	8b 40 24             	mov    0x24(%eax),%eax
8010697e:	85 c0                	test   %eax,%eax
80106980:	74 05                	je     80106987 <trap+0x26>
      exit();
80106982:	e8 be df ff ff       	call   80104945 <exit>
    proc->tf = tf;
80106987:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010698d:	8b 55 08             	mov    0x8(%ebp),%edx
80106990:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
80106993:	e8 db ed ff ff       	call   80105773 <syscall>
    if(proc->killed)
80106998:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010699e:	8b 40 24             	mov    0x24(%eax),%eax
801069a1:	85 c0                	test   %eax,%eax
801069a3:	0f 84 1b 02 00 00    	je     80106bc4 <trap+0x263>
      exit();
801069a9:	e8 97 df ff ff       	call   80104945 <exit>
    return;
801069ae:	e9 11 02 00 00       	jmp    80106bc4 <trap+0x263>
  }

  switch(tf->trapno){
801069b3:	8b 45 08             	mov    0x8(%ebp),%eax
801069b6:	8b 40 30             	mov    0x30(%eax),%eax
801069b9:	83 e8 20             	sub    $0x20,%eax
801069bc:	83 f8 1f             	cmp    $0x1f,%eax
801069bf:	0f 87 c0 00 00 00    	ja     80106a85 <trap+0x124>
801069c5:	8b 04 85 2c 8c 10 80 	mov    -0x7fef73d4(,%eax,4),%eax
801069cc:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpu->id == 0){
801069ce:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801069d4:	0f b6 00             	movzbl (%eax),%eax
801069d7:	84 c0                	test   %al,%al
801069d9:	75 3d                	jne    80106a18 <trap+0xb7>
      acquire(&tickslock);
801069db:	83 ec 0c             	sub    $0xc,%esp
801069de:	68 a0 49 11 80       	push   $0x801149a0
801069e3:	e8 4d e7 ff ff       	call   80105135 <acquire>
801069e8:	83 c4 10             	add    $0x10,%esp
      ticks++;
801069eb:	a1 e0 51 11 80       	mov    0x801151e0,%eax
801069f0:	83 c0 01             	add    $0x1,%eax
801069f3:	a3 e0 51 11 80       	mov    %eax,0x801151e0
      wakeup(&ticks);
801069f8:	83 ec 0c             	sub    $0xc,%esp
801069fb:	68 e0 51 11 80       	push   $0x801151e0
80106a00:	e8 30 e5 ff ff       	call   80104f35 <wakeup>
80106a05:	83 c4 10             	add    $0x10,%esp
      release(&tickslock);
80106a08:	83 ec 0c             	sub    $0xc,%esp
80106a0b:	68 a0 49 11 80       	push   $0x801149a0
80106a10:	e8 87 e7 ff ff       	call   8010519c <release>
80106a15:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
80106a18:	e8 08 c6 ff ff       	call   80103025 <lapiceoi>
    break;
80106a1d:	e9 1c 01 00 00       	jmp    80106b3e <trap+0x1dd>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106a22:	e8 11 be ff ff       	call   80102838 <ideintr>
    lapiceoi();
80106a27:	e8 f9 c5 ff ff       	call   80103025 <lapiceoi>
    break;
80106a2c:	e9 0d 01 00 00       	jmp    80106b3e <trap+0x1dd>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80106a31:	e8 f1 c3 ff ff       	call   80102e27 <kbdintr>
    lapiceoi();
80106a36:	e8 ea c5 ff ff       	call   80103025 <lapiceoi>
    break;
80106a3b:	e9 fe 00 00 00       	jmp    80106b3e <trap+0x1dd>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80106a40:	e8 60 03 00 00       	call   80106da5 <uartintr>
    lapiceoi();
80106a45:	e8 db c5 ff ff       	call   80103025 <lapiceoi>
    break;
80106a4a:	e9 ef 00 00 00       	jmp    80106b3e <trap+0x1dd>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106a4f:	8b 45 08             	mov    0x8(%ebp),%eax
80106a52:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
80106a55:	8b 45 08             	mov    0x8(%ebp),%eax
80106a58:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106a5c:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
80106a5f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106a65:	0f b6 00             	movzbl (%eax),%eax
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106a68:	0f b6 c0             	movzbl %al,%eax
80106a6b:	51                   	push   %ecx
80106a6c:	52                   	push   %edx
80106a6d:	50                   	push   %eax
80106a6e:	68 8c 8b 10 80       	push   $0x80108b8c
80106a73:	e8 4e 99 ff ff       	call   801003c6 <cprintf>
80106a78:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80106a7b:	e8 a5 c5 ff ff       	call   80103025 <lapiceoi>
    break;
80106a80:	e9 b9 00 00 00       	jmp    80106b3e <trap+0x1dd>
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
80106a85:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a8b:	85 c0                	test   %eax,%eax
80106a8d:	74 11                	je     80106aa0 <trap+0x13f>
80106a8f:	8b 45 08             	mov    0x8(%ebp),%eax
80106a92:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106a96:	0f b7 c0             	movzwl %ax,%eax
80106a99:	83 e0 03             	and    $0x3,%eax
80106a9c:	85 c0                	test   %eax,%eax
80106a9e:	75 40                	jne    80106ae0 <trap+0x17f>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106aa0:	e8 1d fd ff ff       	call   801067c2 <rcr2>
80106aa5:	89 c3                	mov    %eax,%ebx
80106aa7:	8b 45 08             	mov    0x8(%ebp),%eax
80106aaa:	8b 48 38             	mov    0x38(%eax),%ecx
              tf->trapno, cpu->id, tf->eip, rcr2());
80106aad:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106ab3:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106ab6:	0f b6 d0             	movzbl %al,%edx
80106ab9:	8b 45 08             	mov    0x8(%ebp),%eax
80106abc:	8b 40 30             	mov    0x30(%eax),%eax
80106abf:	83 ec 0c             	sub    $0xc,%esp
80106ac2:	53                   	push   %ebx
80106ac3:	51                   	push   %ecx
80106ac4:	52                   	push   %edx
80106ac5:	50                   	push   %eax
80106ac6:	68 b0 8b 10 80       	push   $0x80108bb0
80106acb:	e8 f6 98 ff ff       	call   801003c6 <cprintf>
80106ad0:	83 c4 20             	add    $0x20,%esp
      panic("trap");
80106ad3:	83 ec 0c             	sub    $0xc,%esp
80106ad6:	68 e2 8b 10 80       	push   $0x80108be2
80106adb:	e8 86 9a ff ff       	call   80100566 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106ae0:	e8 dd fc ff ff       	call   801067c2 <rcr2>
80106ae5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106ae8:	8b 45 08             	mov    0x8(%ebp),%eax
80106aeb:	8b 70 38             	mov    0x38(%eax),%esi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80106aee:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106af4:	0f b6 00             	movzbl (%eax),%eax
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106af7:	0f b6 d8             	movzbl %al,%ebx
80106afa:	8b 45 08             	mov    0x8(%ebp),%eax
80106afd:	8b 48 34             	mov    0x34(%eax),%ecx
80106b00:	8b 45 08             	mov    0x8(%ebp),%eax
80106b03:	8b 50 30             	mov    0x30(%eax),%edx
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80106b06:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106b0c:	8d 78 6c             	lea    0x6c(%eax),%edi
80106b0f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106b15:	8b 40 10             	mov    0x10(%eax),%eax
80106b18:	ff 75 e4             	pushl  -0x1c(%ebp)
80106b1b:	56                   	push   %esi
80106b1c:	53                   	push   %ebx
80106b1d:	51                   	push   %ecx
80106b1e:	52                   	push   %edx
80106b1f:	57                   	push   %edi
80106b20:	50                   	push   %eax
80106b21:	68 e8 8b 10 80       	push   $0x80108be8
80106b26:	e8 9b 98 ff ff       	call   801003c6 <cprintf>
80106b2b:	83 c4 20             	add    $0x20,%esp
            rcr2());
    proc->killed = 1;
80106b2e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106b34:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80106b3b:	eb 01                	jmp    80106b3e <trap+0x1dd>
    break;
80106b3d:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80106b3e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106b44:	85 c0                	test   %eax,%eax
80106b46:	74 24                	je     80106b6c <trap+0x20b>
80106b48:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106b4e:	8b 40 24             	mov    0x24(%eax),%eax
80106b51:	85 c0                	test   %eax,%eax
80106b53:	74 17                	je     80106b6c <trap+0x20b>
80106b55:	8b 45 08             	mov    0x8(%ebp),%eax
80106b58:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106b5c:	0f b7 c0             	movzwl %ax,%eax
80106b5f:	83 e0 03             	and    $0x3,%eax
80106b62:	83 f8 03             	cmp    $0x3,%eax
80106b65:	75 05                	jne    80106b6c <trap+0x20b>
    exit();
80106b67:	e8 d9 dd ff ff       	call   80104945 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80106b6c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106b72:	85 c0                	test   %eax,%eax
80106b74:	74 1e                	je     80106b94 <trap+0x233>
80106b76:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106b7c:	8b 40 0c             	mov    0xc(%eax),%eax
80106b7f:	83 f8 04             	cmp    $0x4,%eax
80106b82:	75 10                	jne    80106b94 <trap+0x233>
80106b84:	8b 45 08             	mov    0x8(%ebp),%eax
80106b87:	8b 40 30             	mov    0x30(%eax),%eax
80106b8a:	83 f8 20             	cmp    $0x20,%eax
80106b8d:	75 05                	jne    80106b94 <trap+0x233>
    yield();
80106b8f:	e8 35 e2 ff ff       	call   80104dc9 <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80106b94:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106b9a:	85 c0                	test   %eax,%eax
80106b9c:	74 27                	je     80106bc5 <trap+0x264>
80106b9e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106ba4:	8b 40 24             	mov    0x24(%eax),%eax
80106ba7:	85 c0                	test   %eax,%eax
80106ba9:	74 1a                	je     80106bc5 <trap+0x264>
80106bab:	8b 45 08             	mov    0x8(%ebp),%eax
80106bae:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106bb2:	0f b7 c0             	movzwl %ax,%eax
80106bb5:	83 e0 03             	and    $0x3,%eax
80106bb8:	83 f8 03             	cmp    $0x3,%eax
80106bbb:	75 08                	jne    80106bc5 <trap+0x264>
    exit();
80106bbd:	e8 83 dd ff ff       	call   80104945 <exit>
80106bc2:	eb 01                	jmp    80106bc5 <trap+0x264>
    return;
80106bc4:	90                   	nop
}
80106bc5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106bc8:	5b                   	pop    %ebx
80106bc9:	5e                   	pop    %esi
80106bca:	5f                   	pop    %edi
80106bcb:	5d                   	pop    %ebp
80106bcc:	c3                   	ret    

80106bcd <inb>:
{
80106bcd:	55                   	push   %ebp
80106bce:	89 e5                	mov    %esp,%ebp
80106bd0:	83 ec 14             	sub    $0x14,%esp
80106bd3:	8b 45 08             	mov    0x8(%ebp),%eax
80106bd6:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106bda:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80106bde:	89 c2                	mov    %eax,%edx
80106be0:	ec                   	in     (%dx),%al
80106be1:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80106be4:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80106be8:	c9                   	leave  
80106be9:	c3                   	ret    

80106bea <outb>:
{
80106bea:	55                   	push   %ebp
80106beb:	89 e5                	mov    %esp,%ebp
80106bed:	83 ec 08             	sub    $0x8,%esp
80106bf0:	8b 55 08             	mov    0x8(%ebp),%edx
80106bf3:	8b 45 0c             	mov    0xc(%ebp),%eax
80106bf6:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106bfa:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106bfd:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106c01:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106c05:	ee                   	out    %al,(%dx)
}
80106c06:	90                   	nop
80106c07:	c9                   	leave  
80106c08:	c3                   	ret    

80106c09 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80106c09:	55                   	push   %ebp
80106c0a:	89 e5                	mov    %esp,%ebp
80106c0c:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80106c0f:	6a 00                	push   $0x0
80106c11:	68 fa 03 00 00       	push   $0x3fa
80106c16:	e8 cf ff ff ff       	call   80106bea <outb>
80106c1b:	83 c4 08             	add    $0x8,%esp
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80106c1e:	68 80 00 00 00       	push   $0x80
80106c23:	68 fb 03 00 00       	push   $0x3fb
80106c28:	e8 bd ff ff ff       	call   80106bea <outb>
80106c2d:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
80106c30:	6a 0c                	push   $0xc
80106c32:	68 f8 03 00 00       	push   $0x3f8
80106c37:	e8 ae ff ff ff       	call   80106bea <outb>
80106c3c:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
80106c3f:	6a 00                	push   $0x0
80106c41:	68 f9 03 00 00       	push   $0x3f9
80106c46:	e8 9f ff ff ff       	call   80106bea <outb>
80106c4b:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80106c4e:	6a 03                	push   $0x3
80106c50:	68 fb 03 00 00       	push   $0x3fb
80106c55:	e8 90 ff ff ff       	call   80106bea <outb>
80106c5a:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
80106c5d:	6a 00                	push   $0x0
80106c5f:	68 fc 03 00 00       	push   $0x3fc
80106c64:	e8 81 ff ff ff       	call   80106bea <outb>
80106c69:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80106c6c:	6a 01                	push   $0x1
80106c6e:	68 f9 03 00 00       	push   $0x3f9
80106c73:	e8 72 ff ff ff       	call   80106bea <outb>
80106c78:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80106c7b:	68 fd 03 00 00       	push   $0x3fd
80106c80:	e8 48 ff ff ff       	call   80106bcd <inb>
80106c85:	83 c4 04             	add    $0x4,%esp
80106c88:	3c ff                	cmp    $0xff,%al
80106c8a:	74 6e                	je     80106cfa <uartinit+0xf1>
    return;
  uart = 1;
80106c8c:	c7 05 4c b6 10 80 01 	movl   $0x1,0x8010b64c
80106c93:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80106c96:	68 fa 03 00 00       	push   $0x3fa
80106c9b:	e8 2d ff ff ff       	call   80106bcd <inb>
80106ca0:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
80106ca3:	68 f8 03 00 00       	push   $0x3f8
80106ca8:	e8 20 ff ff ff       	call   80106bcd <inb>
80106cad:	83 c4 04             	add    $0x4,%esp
  picenable(IRQ_COM1);
80106cb0:	83 ec 0c             	sub    $0xc,%esp
80106cb3:	6a 04                	push   $0x4
80106cb5:	e8 71 d2 ff ff       	call   80103f2b <picenable>
80106cba:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_COM1, 0);
80106cbd:	83 ec 08             	sub    $0x8,%esp
80106cc0:	6a 00                	push   $0x0
80106cc2:	6a 04                	push   $0x4
80106cc4:	e8 11 be ff ff       	call   80102ada <ioapicenable>
80106cc9:	83 c4 10             	add    $0x10,%esp
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106ccc:	c7 45 f4 ac 8c 10 80 	movl   $0x80108cac,-0xc(%ebp)
80106cd3:	eb 19                	jmp    80106cee <uartinit+0xe5>
    uartputc(*p);
80106cd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106cd8:	0f b6 00             	movzbl (%eax),%eax
80106cdb:	0f be c0             	movsbl %al,%eax
80106cde:	83 ec 0c             	sub    $0xc,%esp
80106ce1:	50                   	push   %eax
80106ce2:	e8 16 00 00 00       	call   80106cfd <uartputc>
80106ce7:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106cea:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106cee:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106cf1:	0f b6 00             	movzbl (%eax),%eax
80106cf4:	84 c0                	test   %al,%al
80106cf6:	75 dd                	jne    80106cd5 <uartinit+0xcc>
80106cf8:	eb 01                	jmp    80106cfb <uartinit+0xf2>
    return;
80106cfa:	90                   	nop
}
80106cfb:	c9                   	leave  
80106cfc:	c3                   	ret    

80106cfd <uartputc>:

void
uartputc(int c)
{
80106cfd:	55                   	push   %ebp
80106cfe:	89 e5                	mov    %esp,%ebp
80106d00:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
80106d03:	a1 4c b6 10 80       	mov    0x8010b64c,%eax
80106d08:	85 c0                	test   %eax,%eax
80106d0a:	74 53                	je     80106d5f <uartputc+0x62>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106d0c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106d13:	eb 11                	jmp    80106d26 <uartputc+0x29>
    microdelay(10);
80106d15:	83 ec 0c             	sub    $0xc,%esp
80106d18:	6a 0a                	push   $0xa
80106d1a:	e8 21 c3 ff ff       	call   80103040 <microdelay>
80106d1f:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106d22:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106d26:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80106d2a:	7f 1a                	jg     80106d46 <uartputc+0x49>
80106d2c:	83 ec 0c             	sub    $0xc,%esp
80106d2f:	68 fd 03 00 00       	push   $0x3fd
80106d34:	e8 94 fe ff ff       	call   80106bcd <inb>
80106d39:	83 c4 10             	add    $0x10,%esp
80106d3c:	0f b6 c0             	movzbl %al,%eax
80106d3f:	83 e0 20             	and    $0x20,%eax
80106d42:	85 c0                	test   %eax,%eax
80106d44:	74 cf                	je     80106d15 <uartputc+0x18>
  outb(COM1+0, c);
80106d46:	8b 45 08             	mov    0x8(%ebp),%eax
80106d49:	0f b6 c0             	movzbl %al,%eax
80106d4c:	83 ec 08             	sub    $0x8,%esp
80106d4f:	50                   	push   %eax
80106d50:	68 f8 03 00 00       	push   $0x3f8
80106d55:	e8 90 fe ff ff       	call   80106bea <outb>
80106d5a:	83 c4 10             	add    $0x10,%esp
80106d5d:	eb 01                	jmp    80106d60 <uartputc+0x63>
    return;
80106d5f:	90                   	nop
}
80106d60:	c9                   	leave  
80106d61:	c3                   	ret    

80106d62 <uartgetc>:

static int
uartgetc(void)
{
80106d62:	55                   	push   %ebp
80106d63:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106d65:	a1 4c b6 10 80       	mov    0x8010b64c,%eax
80106d6a:	85 c0                	test   %eax,%eax
80106d6c:	75 07                	jne    80106d75 <uartgetc+0x13>
    return -1;
80106d6e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d73:	eb 2e                	jmp    80106da3 <uartgetc+0x41>
  if(!(inb(COM1+5) & 0x01))
80106d75:	68 fd 03 00 00       	push   $0x3fd
80106d7a:	e8 4e fe ff ff       	call   80106bcd <inb>
80106d7f:	83 c4 04             	add    $0x4,%esp
80106d82:	0f b6 c0             	movzbl %al,%eax
80106d85:	83 e0 01             	and    $0x1,%eax
80106d88:	85 c0                	test   %eax,%eax
80106d8a:	75 07                	jne    80106d93 <uartgetc+0x31>
    return -1;
80106d8c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d91:	eb 10                	jmp    80106da3 <uartgetc+0x41>
  return inb(COM1+0);
80106d93:	68 f8 03 00 00       	push   $0x3f8
80106d98:	e8 30 fe ff ff       	call   80106bcd <inb>
80106d9d:	83 c4 04             	add    $0x4,%esp
80106da0:	0f b6 c0             	movzbl %al,%eax
}
80106da3:	c9                   	leave  
80106da4:	c3                   	ret    

80106da5 <uartintr>:

void
uartintr(void)
{
80106da5:	55                   	push   %ebp
80106da6:	89 e5                	mov    %esp,%ebp
80106da8:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
80106dab:	83 ec 0c             	sub    $0xc,%esp
80106dae:	68 62 6d 10 80       	push   $0x80106d62
80106db3:	e8 41 9a ff ff       	call   801007f9 <consoleintr>
80106db8:	83 c4 10             	add    $0x10,%esp
}
80106dbb:	90                   	nop
80106dbc:	c9                   	leave  
80106dbd:	c3                   	ret    

80106dbe <vector0>:
80106dbe:	6a 00                	push   $0x0
80106dc0:	6a 00                	push   $0x0
80106dc2:	e9 a6 f9 ff ff       	jmp    8010676d <alltraps>

80106dc7 <vector1>:
80106dc7:	6a 00                	push   $0x0
80106dc9:	6a 01                	push   $0x1
80106dcb:	e9 9d f9 ff ff       	jmp    8010676d <alltraps>

80106dd0 <vector2>:
80106dd0:	6a 00                	push   $0x0
80106dd2:	6a 02                	push   $0x2
80106dd4:	e9 94 f9 ff ff       	jmp    8010676d <alltraps>

80106dd9 <vector3>:
80106dd9:	6a 00                	push   $0x0
80106ddb:	6a 03                	push   $0x3
80106ddd:	e9 8b f9 ff ff       	jmp    8010676d <alltraps>

80106de2 <vector4>:
80106de2:	6a 00                	push   $0x0
80106de4:	6a 04                	push   $0x4
80106de6:	e9 82 f9 ff ff       	jmp    8010676d <alltraps>

80106deb <vector5>:
80106deb:	6a 00                	push   $0x0
80106ded:	6a 05                	push   $0x5
80106def:	e9 79 f9 ff ff       	jmp    8010676d <alltraps>

80106df4 <vector6>:
80106df4:	6a 00                	push   $0x0
80106df6:	6a 06                	push   $0x6
80106df8:	e9 70 f9 ff ff       	jmp    8010676d <alltraps>

80106dfd <vector7>:
80106dfd:	6a 00                	push   $0x0
80106dff:	6a 07                	push   $0x7
80106e01:	e9 67 f9 ff ff       	jmp    8010676d <alltraps>

80106e06 <vector8>:
80106e06:	6a 08                	push   $0x8
80106e08:	e9 60 f9 ff ff       	jmp    8010676d <alltraps>

80106e0d <vector9>:
80106e0d:	6a 00                	push   $0x0
80106e0f:	6a 09                	push   $0x9
80106e11:	e9 57 f9 ff ff       	jmp    8010676d <alltraps>

80106e16 <vector10>:
80106e16:	6a 0a                	push   $0xa
80106e18:	e9 50 f9 ff ff       	jmp    8010676d <alltraps>

80106e1d <vector11>:
80106e1d:	6a 0b                	push   $0xb
80106e1f:	e9 49 f9 ff ff       	jmp    8010676d <alltraps>

80106e24 <vector12>:
80106e24:	6a 0c                	push   $0xc
80106e26:	e9 42 f9 ff ff       	jmp    8010676d <alltraps>

80106e2b <vector13>:
80106e2b:	6a 0d                	push   $0xd
80106e2d:	e9 3b f9 ff ff       	jmp    8010676d <alltraps>

80106e32 <vector14>:
80106e32:	6a 0e                	push   $0xe
80106e34:	e9 34 f9 ff ff       	jmp    8010676d <alltraps>

80106e39 <vector15>:
80106e39:	6a 00                	push   $0x0
80106e3b:	6a 0f                	push   $0xf
80106e3d:	e9 2b f9 ff ff       	jmp    8010676d <alltraps>

80106e42 <vector16>:
80106e42:	6a 00                	push   $0x0
80106e44:	6a 10                	push   $0x10
80106e46:	e9 22 f9 ff ff       	jmp    8010676d <alltraps>

80106e4b <vector17>:
80106e4b:	6a 11                	push   $0x11
80106e4d:	e9 1b f9 ff ff       	jmp    8010676d <alltraps>

80106e52 <vector18>:
80106e52:	6a 00                	push   $0x0
80106e54:	6a 12                	push   $0x12
80106e56:	e9 12 f9 ff ff       	jmp    8010676d <alltraps>

80106e5b <vector19>:
80106e5b:	6a 00                	push   $0x0
80106e5d:	6a 13                	push   $0x13
80106e5f:	e9 09 f9 ff ff       	jmp    8010676d <alltraps>

80106e64 <vector20>:
80106e64:	6a 00                	push   $0x0
80106e66:	6a 14                	push   $0x14
80106e68:	e9 00 f9 ff ff       	jmp    8010676d <alltraps>

80106e6d <vector21>:
80106e6d:	6a 00                	push   $0x0
80106e6f:	6a 15                	push   $0x15
80106e71:	e9 f7 f8 ff ff       	jmp    8010676d <alltraps>

80106e76 <vector22>:
80106e76:	6a 00                	push   $0x0
80106e78:	6a 16                	push   $0x16
80106e7a:	e9 ee f8 ff ff       	jmp    8010676d <alltraps>

80106e7f <vector23>:
80106e7f:	6a 00                	push   $0x0
80106e81:	6a 17                	push   $0x17
80106e83:	e9 e5 f8 ff ff       	jmp    8010676d <alltraps>

80106e88 <vector24>:
80106e88:	6a 00                	push   $0x0
80106e8a:	6a 18                	push   $0x18
80106e8c:	e9 dc f8 ff ff       	jmp    8010676d <alltraps>

80106e91 <vector25>:
80106e91:	6a 00                	push   $0x0
80106e93:	6a 19                	push   $0x19
80106e95:	e9 d3 f8 ff ff       	jmp    8010676d <alltraps>

80106e9a <vector26>:
80106e9a:	6a 00                	push   $0x0
80106e9c:	6a 1a                	push   $0x1a
80106e9e:	e9 ca f8 ff ff       	jmp    8010676d <alltraps>

80106ea3 <vector27>:
80106ea3:	6a 00                	push   $0x0
80106ea5:	6a 1b                	push   $0x1b
80106ea7:	e9 c1 f8 ff ff       	jmp    8010676d <alltraps>

80106eac <vector28>:
80106eac:	6a 00                	push   $0x0
80106eae:	6a 1c                	push   $0x1c
80106eb0:	e9 b8 f8 ff ff       	jmp    8010676d <alltraps>

80106eb5 <vector29>:
80106eb5:	6a 00                	push   $0x0
80106eb7:	6a 1d                	push   $0x1d
80106eb9:	e9 af f8 ff ff       	jmp    8010676d <alltraps>

80106ebe <vector30>:
80106ebe:	6a 00                	push   $0x0
80106ec0:	6a 1e                	push   $0x1e
80106ec2:	e9 a6 f8 ff ff       	jmp    8010676d <alltraps>

80106ec7 <vector31>:
80106ec7:	6a 00                	push   $0x0
80106ec9:	6a 1f                	push   $0x1f
80106ecb:	e9 9d f8 ff ff       	jmp    8010676d <alltraps>

80106ed0 <vector32>:
80106ed0:	6a 00                	push   $0x0
80106ed2:	6a 20                	push   $0x20
80106ed4:	e9 94 f8 ff ff       	jmp    8010676d <alltraps>

80106ed9 <vector33>:
80106ed9:	6a 00                	push   $0x0
80106edb:	6a 21                	push   $0x21
80106edd:	e9 8b f8 ff ff       	jmp    8010676d <alltraps>

80106ee2 <vector34>:
80106ee2:	6a 00                	push   $0x0
80106ee4:	6a 22                	push   $0x22
80106ee6:	e9 82 f8 ff ff       	jmp    8010676d <alltraps>

80106eeb <vector35>:
80106eeb:	6a 00                	push   $0x0
80106eed:	6a 23                	push   $0x23
80106eef:	e9 79 f8 ff ff       	jmp    8010676d <alltraps>

80106ef4 <vector36>:
80106ef4:	6a 00                	push   $0x0
80106ef6:	6a 24                	push   $0x24
80106ef8:	e9 70 f8 ff ff       	jmp    8010676d <alltraps>

80106efd <vector37>:
80106efd:	6a 00                	push   $0x0
80106eff:	6a 25                	push   $0x25
80106f01:	e9 67 f8 ff ff       	jmp    8010676d <alltraps>

80106f06 <vector38>:
80106f06:	6a 00                	push   $0x0
80106f08:	6a 26                	push   $0x26
80106f0a:	e9 5e f8 ff ff       	jmp    8010676d <alltraps>

80106f0f <vector39>:
80106f0f:	6a 00                	push   $0x0
80106f11:	6a 27                	push   $0x27
80106f13:	e9 55 f8 ff ff       	jmp    8010676d <alltraps>

80106f18 <vector40>:
80106f18:	6a 00                	push   $0x0
80106f1a:	6a 28                	push   $0x28
80106f1c:	e9 4c f8 ff ff       	jmp    8010676d <alltraps>

80106f21 <vector41>:
80106f21:	6a 00                	push   $0x0
80106f23:	6a 29                	push   $0x29
80106f25:	e9 43 f8 ff ff       	jmp    8010676d <alltraps>

80106f2a <vector42>:
80106f2a:	6a 00                	push   $0x0
80106f2c:	6a 2a                	push   $0x2a
80106f2e:	e9 3a f8 ff ff       	jmp    8010676d <alltraps>

80106f33 <vector43>:
80106f33:	6a 00                	push   $0x0
80106f35:	6a 2b                	push   $0x2b
80106f37:	e9 31 f8 ff ff       	jmp    8010676d <alltraps>

80106f3c <vector44>:
80106f3c:	6a 00                	push   $0x0
80106f3e:	6a 2c                	push   $0x2c
80106f40:	e9 28 f8 ff ff       	jmp    8010676d <alltraps>

80106f45 <vector45>:
80106f45:	6a 00                	push   $0x0
80106f47:	6a 2d                	push   $0x2d
80106f49:	e9 1f f8 ff ff       	jmp    8010676d <alltraps>

80106f4e <vector46>:
80106f4e:	6a 00                	push   $0x0
80106f50:	6a 2e                	push   $0x2e
80106f52:	e9 16 f8 ff ff       	jmp    8010676d <alltraps>

80106f57 <vector47>:
80106f57:	6a 00                	push   $0x0
80106f59:	6a 2f                	push   $0x2f
80106f5b:	e9 0d f8 ff ff       	jmp    8010676d <alltraps>

80106f60 <vector48>:
80106f60:	6a 00                	push   $0x0
80106f62:	6a 30                	push   $0x30
80106f64:	e9 04 f8 ff ff       	jmp    8010676d <alltraps>

80106f69 <vector49>:
80106f69:	6a 00                	push   $0x0
80106f6b:	6a 31                	push   $0x31
80106f6d:	e9 fb f7 ff ff       	jmp    8010676d <alltraps>

80106f72 <vector50>:
80106f72:	6a 00                	push   $0x0
80106f74:	6a 32                	push   $0x32
80106f76:	e9 f2 f7 ff ff       	jmp    8010676d <alltraps>

80106f7b <vector51>:
80106f7b:	6a 00                	push   $0x0
80106f7d:	6a 33                	push   $0x33
80106f7f:	e9 e9 f7 ff ff       	jmp    8010676d <alltraps>

80106f84 <vector52>:
80106f84:	6a 00                	push   $0x0
80106f86:	6a 34                	push   $0x34
80106f88:	e9 e0 f7 ff ff       	jmp    8010676d <alltraps>

80106f8d <vector53>:
80106f8d:	6a 00                	push   $0x0
80106f8f:	6a 35                	push   $0x35
80106f91:	e9 d7 f7 ff ff       	jmp    8010676d <alltraps>

80106f96 <vector54>:
80106f96:	6a 00                	push   $0x0
80106f98:	6a 36                	push   $0x36
80106f9a:	e9 ce f7 ff ff       	jmp    8010676d <alltraps>

80106f9f <vector55>:
80106f9f:	6a 00                	push   $0x0
80106fa1:	6a 37                	push   $0x37
80106fa3:	e9 c5 f7 ff ff       	jmp    8010676d <alltraps>

80106fa8 <vector56>:
80106fa8:	6a 00                	push   $0x0
80106faa:	6a 38                	push   $0x38
80106fac:	e9 bc f7 ff ff       	jmp    8010676d <alltraps>

80106fb1 <vector57>:
80106fb1:	6a 00                	push   $0x0
80106fb3:	6a 39                	push   $0x39
80106fb5:	e9 b3 f7 ff ff       	jmp    8010676d <alltraps>

80106fba <vector58>:
80106fba:	6a 00                	push   $0x0
80106fbc:	6a 3a                	push   $0x3a
80106fbe:	e9 aa f7 ff ff       	jmp    8010676d <alltraps>

80106fc3 <vector59>:
80106fc3:	6a 00                	push   $0x0
80106fc5:	6a 3b                	push   $0x3b
80106fc7:	e9 a1 f7 ff ff       	jmp    8010676d <alltraps>

80106fcc <vector60>:
80106fcc:	6a 00                	push   $0x0
80106fce:	6a 3c                	push   $0x3c
80106fd0:	e9 98 f7 ff ff       	jmp    8010676d <alltraps>

80106fd5 <vector61>:
80106fd5:	6a 00                	push   $0x0
80106fd7:	6a 3d                	push   $0x3d
80106fd9:	e9 8f f7 ff ff       	jmp    8010676d <alltraps>

80106fde <vector62>:
80106fde:	6a 00                	push   $0x0
80106fe0:	6a 3e                	push   $0x3e
80106fe2:	e9 86 f7 ff ff       	jmp    8010676d <alltraps>

80106fe7 <vector63>:
80106fe7:	6a 00                	push   $0x0
80106fe9:	6a 3f                	push   $0x3f
80106feb:	e9 7d f7 ff ff       	jmp    8010676d <alltraps>

80106ff0 <vector64>:
80106ff0:	6a 00                	push   $0x0
80106ff2:	6a 40                	push   $0x40
80106ff4:	e9 74 f7 ff ff       	jmp    8010676d <alltraps>

80106ff9 <vector65>:
80106ff9:	6a 00                	push   $0x0
80106ffb:	6a 41                	push   $0x41
80106ffd:	e9 6b f7 ff ff       	jmp    8010676d <alltraps>

80107002 <vector66>:
80107002:	6a 00                	push   $0x0
80107004:	6a 42                	push   $0x42
80107006:	e9 62 f7 ff ff       	jmp    8010676d <alltraps>

8010700b <vector67>:
8010700b:	6a 00                	push   $0x0
8010700d:	6a 43                	push   $0x43
8010700f:	e9 59 f7 ff ff       	jmp    8010676d <alltraps>

80107014 <vector68>:
80107014:	6a 00                	push   $0x0
80107016:	6a 44                	push   $0x44
80107018:	e9 50 f7 ff ff       	jmp    8010676d <alltraps>

8010701d <vector69>:
8010701d:	6a 00                	push   $0x0
8010701f:	6a 45                	push   $0x45
80107021:	e9 47 f7 ff ff       	jmp    8010676d <alltraps>

80107026 <vector70>:
80107026:	6a 00                	push   $0x0
80107028:	6a 46                	push   $0x46
8010702a:	e9 3e f7 ff ff       	jmp    8010676d <alltraps>

8010702f <vector71>:
8010702f:	6a 00                	push   $0x0
80107031:	6a 47                	push   $0x47
80107033:	e9 35 f7 ff ff       	jmp    8010676d <alltraps>

80107038 <vector72>:
80107038:	6a 00                	push   $0x0
8010703a:	6a 48                	push   $0x48
8010703c:	e9 2c f7 ff ff       	jmp    8010676d <alltraps>

80107041 <vector73>:
80107041:	6a 00                	push   $0x0
80107043:	6a 49                	push   $0x49
80107045:	e9 23 f7 ff ff       	jmp    8010676d <alltraps>

8010704a <vector74>:
8010704a:	6a 00                	push   $0x0
8010704c:	6a 4a                	push   $0x4a
8010704e:	e9 1a f7 ff ff       	jmp    8010676d <alltraps>

80107053 <vector75>:
80107053:	6a 00                	push   $0x0
80107055:	6a 4b                	push   $0x4b
80107057:	e9 11 f7 ff ff       	jmp    8010676d <alltraps>

8010705c <vector76>:
8010705c:	6a 00                	push   $0x0
8010705e:	6a 4c                	push   $0x4c
80107060:	e9 08 f7 ff ff       	jmp    8010676d <alltraps>

80107065 <vector77>:
80107065:	6a 00                	push   $0x0
80107067:	6a 4d                	push   $0x4d
80107069:	e9 ff f6 ff ff       	jmp    8010676d <alltraps>

8010706e <vector78>:
8010706e:	6a 00                	push   $0x0
80107070:	6a 4e                	push   $0x4e
80107072:	e9 f6 f6 ff ff       	jmp    8010676d <alltraps>

80107077 <vector79>:
80107077:	6a 00                	push   $0x0
80107079:	6a 4f                	push   $0x4f
8010707b:	e9 ed f6 ff ff       	jmp    8010676d <alltraps>

80107080 <vector80>:
80107080:	6a 00                	push   $0x0
80107082:	6a 50                	push   $0x50
80107084:	e9 e4 f6 ff ff       	jmp    8010676d <alltraps>

80107089 <vector81>:
80107089:	6a 00                	push   $0x0
8010708b:	6a 51                	push   $0x51
8010708d:	e9 db f6 ff ff       	jmp    8010676d <alltraps>

80107092 <vector82>:
80107092:	6a 00                	push   $0x0
80107094:	6a 52                	push   $0x52
80107096:	e9 d2 f6 ff ff       	jmp    8010676d <alltraps>

8010709b <vector83>:
8010709b:	6a 00                	push   $0x0
8010709d:	6a 53                	push   $0x53
8010709f:	e9 c9 f6 ff ff       	jmp    8010676d <alltraps>

801070a4 <vector84>:
801070a4:	6a 00                	push   $0x0
801070a6:	6a 54                	push   $0x54
801070a8:	e9 c0 f6 ff ff       	jmp    8010676d <alltraps>

801070ad <vector85>:
801070ad:	6a 00                	push   $0x0
801070af:	6a 55                	push   $0x55
801070b1:	e9 b7 f6 ff ff       	jmp    8010676d <alltraps>

801070b6 <vector86>:
801070b6:	6a 00                	push   $0x0
801070b8:	6a 56                	push   $0x56
801070ba:	e9 ae f6 ff ff       	jmp    8010676d <alltraps>

801070bf <vector87>:
801070bf:	6a 00                	push   $0x0
801070c1:	6a 57                	push   $0x57
801070c3:	e9 a5 f6 ff ff       	jmp    8010676d <alltraps>

801070c8 <vector88>:
801070c8:	6a 00                	push   $0x0
801070ca:	6a 58                	push   $0x58
801070cc:	e9 9c f6 ff ff       	jmp    8010676d <alltraps>

801070d1 <vector89>:
801070d1:	6a 00                	push   $0x0
801070d3:	6a 59                	push   $0x59
801070d5:	e9 93 f6 ff ff       	jmp    8010676d <alltraps>

801070da <vector90>:
801070da:	6a 00                	push   $0x0
801070dc:	6a 5a                	push   $0x5a
801070de:	e9 8a f6 ff ff       	jmp    8010676d <alltraps>

801070e3 <vector91>:
801070e3:	6a 00                	push   $0x0
801070e5:	6a 5b                	push   $0x5b
801070e7:	e9 81 f6 ff ff       	jmp    8010676d <alltraps>

801070ec <vector92>:
801070ec:	6a 00                	push   $0x0
801070ee:	6a 5c                	push   $0x5c
801070f0:	e9 78 f6 ff ff       	jmp    8010676d <alltraps>

801070f5 <vector93>:
801070f5:	6a 00                	push   $0x0
801070f7:	6a 5d                	push   $0x5d
801070f9:	e9 6f f6 ff ff       	jmp    8010676d <alltraps>

801070fe <vector94>:
801070fe:	6a 00                	push   $0x0
80107100:	6a 5e                	push   $0x5e
80107102:	e9 66 f6 ff ff       	jmp    8010676d <alltraps>

80107107 <vector95>:
80107107:	6a 00                	push   $0x0
80107109:	6a 5f                	push   $0x5f
8010710b:	e9 5d f6 ff ff       	jmp    8010676d <alltraps>

80107110 <vector96>:
80107110:	6a 00                	push   $0x0
80107112:	6a 60                	push   $0x60
80107114:	e9 54 f6 ff ff       	jmp    8010676d <alltraps>

80107119 <vector97>:
80107119:	6a 00                	push   $0x0
8010711b:	6a 61                	push   $0x61
8010711d:	e9 4b f6 ff ff       	jmp    8010676d <alltraps>

80107122 <vector98>:
80107122:	6a 00                	push   $0x0
80107124:	6a 62                	push   $0x62
80107126:	e9 42 f6 ff ff       	jmp    8010676d <alltraps>

8010712b <vector99>:
8010712b:	6a 00                	push   $0x0
8010712d:	6a 63                	push   $0x63
8010712f:	e9 39 f6 ff ff       	jmp    8010676d <alltraps>

80107134 <vector100>:
80107134:	6a 00                	push   $0x0
80107136:	6a 64                	push   $0x64
80107138:	e9 30 f6 ff ff       	jmp    8010676d <alltraps>

8010713d <vector101>:
8010713d:	6a 00                	push   $0x0
8010713f:	6a 65                	push   $0x65
80107141:	e9 27 f6 ff ff       	jmp    8010676d <alltraps>

80107146 <vector102>:
80107146:	6a 00                	push   $0x0
80107148:	6a 66                	push   $0x66
8010714a:	e9 1e f6 ff ff       	jmp    8010676d <alltraps>

8010714f <vector103>:
8010714f:	6a 00                	push   $0x0
80107151:	6a 67                	push   $0x67
80107153:	e9 15 f6 ff ff       	jmp    8010676d <alltraps>

80107158 <vector104>:
80107158:	6a 00                	push   $0x0
8010715a:	6a 68                	push   $0x68
8010715c:	e9 0c f6 ff ff       	jmp    8010676d <alltraps>

80107161 <vector105>:
80107161:	6a 00                	push   $0x0
80107163:	6a 69                	push   $0x69
80107165:	e9 03 f6 ff ff       	jmp    8010676d <alltraps>

8010716a <vector106>:
8010716a:	6a 00                	push   $0x0
8010716c:	6a 6a                	push   $0x6a
8010716e:	e9 fa f5 ff ff       	jmp    8010676d <alltraps>

80107173 <vector107>:
80107173:	6a 00                	push   $0x0
80107175:	6a 6b                	push   $0x6b
80107177:	e9 f1 f5 ff ff       	jmp    8010676d <alltraps>

8010717c <vector108>:
8010717c:	6a 00                	push   $0x0
8010717e:	6a 6c                	push   $0x6c
80107180:	e9 e8 f5 ff ff       	jmp    8010676d <alltraps>

80107185 <vector109>:
80107185:	6a 00                	push   $0x0
80107187:	6a 6d                	push   $0x6d
80107189:	e9 df f5 ff ff       	jmp    8010676d <alltraps>

8010718e <vector110>:
8010718e:	6a 00                	push   $0x0
80107190:	6a 6e                	push   $0x6e
80107192:	e9 d6 f5 ff ff       	jmp    8010676d <alltraps>

80107197 <vector111>:
80107197:	6a 00                	push   $0x0
80107199:	6a 6f                	push   $0x6f
8010719b:	e9 cd f5 ff ff       	jmp    8010676d <alltraps>

801071a0 <vector112>:
801071a0:	6a 00                	push   $0x0
801071a2:	6a 70                	push   $0x70
801071a4:	e9 c4 f5 ff ff       	jmp    8010676d <alltraps>

801071a9 <vector113>:
801071a9:	6a 00                	push   $0x0
801071ab:	6a 71                	push   $0x71
801071ad:	e9 bb f5 ff ff       	jmp    8010676d <alltraps>

801071b2 <vector114>:
801071b2:	6a 00                	push   $0x0
801071b4:	6a 72                	push   $0x72
801071b6:	e9 b2 f5 ff ff       	jmp    8010676d <alltraps>

801071bb <vector115>:
801071bb:	6a 00                	push   $0x0
801071bd:	6a 73                	push   $0x73
801071bf:	e9 a9 f5 ff ff       	jmp    8010676d <alltraps>

801071c4 <vector116>:
801071c4:	6a 00                	push   $0x0
801071c6:	6a 74                	push   $0x74
801071c8:	e9 a0 f5 ff ff       	jmp    8010676d <alltraps>

801071cd <vector117>:
801071cd:	6a 00                	push   $0x0
801071cf:	6a 75                	push   $0x75
801071d1:	e9 97 f5 ff ff       	jmp    8010676d <alltraps>

801071d6 <vector118>:
801071d6:	6a 00                	push   $0x0
801071d8:	6a 76                	push   $0x76
801071da:	e9 8e f5 ff ff       	jmp    8010676d <alltraps>

801071df <vector119>:
801071df:	6a 00                	push   $0x0
801071e1:	6a 77                	push   $0x77
801071e3:	e9 85 f5 ff ff       	jmp    8010676d <alltraps>

801071e8 <vector120>:
801071e8:	6a 00                	push   $0x0
801071ea:	6a 78                	push   $0x78
801071ec:	e9 7c f5 ff ff       	jmp    8010676d <alltraps>

801071f1 <vector121>:
801071f1:	6a 00                	push   $0x0
801071f3:	6a 79                	push   $0x79
801071f5:	e9 73 f5 ff ff       	jmp    8010676d <alltraps>

801071fa <vector122>:
801071fa:	6a 00                	push   $0x0
801071fc:	6a 7a                	push   $0x7a
801071fe:	e9 6a f5 ff ff       	jmp    8010676d <alltraps>

80107203 <vector123>:
80107203:	6a 00                	push   $0x0
80107205:	6a 7b                	push   $0x7b
80107207:	e9 61 f5 ff ff       	jmp    8010676d <alltraps>

8010720c <vector124>:
8010720c:	6a 00                	push   $0x0
8010720e:	6a 7c                	push   $0x7c
80107210:	e9 58 f5 ff ff       	jmp    8010676d <alltraps>

80107215 <vector125>:
80107215:	6a 00                	push   $0x0
80107217:	6a 7d                	push   $0x7d
80107219:	e9 4f f5 ff ff       	jmp    8010676d <alltraps>

8010721e <vector126>:
8010721e:	6a 00                	push   $0x0
80107220:	6a 7e                	push   $0x7e
80107222:	e9 46 f5 ff ff       	jmp    8010676d <alltraps>

80107227 <vector127>:
80107227:	6a 00                	push   $0x0
80107229:	6a 7f                	push   $0x7f
8010722b:	e9 3d f5 ff ff       	jmp    8010676d <alltraps>

80107230 <vector128>:
80107230:	6a 00                	push   $0x0
80107232:	68 80 00 00 00       	push   $0x80
80107237:	e9 31 f5 ff ff       	jmp    8010676d <alltraps>

8010723c <vector129>:
8010723c:	6a 00                	push   $0x0
8010723e:	68 81 00 00 00       	push   $0x81
80107243:	e9 25 f5 ff ff       	jmp    8010676d <alltraps>

80107248 <vector130>:
80107248:	6a 00                	push   $0x0
8010724a:	68 82 00 00 00       	push   $0x82
8010724f:	e9 19 f5 ff ff       	jmp    8010676d <alltraps>

80107254 <vector131>:
80107254:	6a 00                	push   $0x0
80107256:	68 83 00 00 00       	push   $0x83
8010725b:	e9 0d f5 ff ff       	jmp    8010676d <alltraps>

80107260 <vector132>:
80107260:	6a 00                	push   $0x0
80107262:	68 84 00 00 00       	push   $0x84
80107267:	e9 01 f5 ff ff       	jmp    8010676d <alltraps>

8010726c <vector133>:
8010726c:	6a 00                	push   $0x0
8010726e:	68 85 00 00 00       	push   $0x85
80107273:	e9 f5 f4 ff ff       	jmp    8010676d <alltraps>

80107278 <vector134>:
80107278:	6a 00                	push   $0x0
8010727a:	68 86 00 00 00       	push   $0x86
8010727f:	e9 e9 f4 ff ff       	jmp    8010676d <alltraps>

80107284 <vector135>:
80107284:	6a 00                	push   $0x0
80107286:	68 87 00 00 00       	push   $0x87
8010728b:	e9 dd f4 ff ff       	jmp    8010676d <alltraps>

80107290 <vector136>:
80107290:	6a 00                	push   $0x0
80107292:	68 88 00 00 00       	push   $0x88
80107297:	e9 d1 f4 ff ff       	jmp    8010676d <alltraps>

8010729c <vector137>:
8010729c:	6a 00                	push   $0x0
8010729e:	68 89 00 00 00       	push   $0x89
801072a3:	e9 c5 f4 ff ff       	jmp    8010676d <alltraps>

801072a8 <vector138>:
801072a8:	6a 00                	push   $0x0
801072aa:	68 8a 00 00 00       	push   $0x8a
801072af:	e9 b9 f4 ff ff       	jmp    8010676d <alltraps>

801072b4 <vector139>:
801072b4:	6a 00                	push   $0x0
801072b6:	68 8b 00 00 00       	push   $0x8b
801072bb:	e9 ad f4 ff ff       	jmp    8010676d <alltraps>

801072c0 <vector140>:
801072c0:	6a 00                	push   $0x0
801072c2:	68 8c 00 00 00       	push   $0x8c
801072c7:	e9 a1 f4 ff ff       	jmp    8010676d <alltraps>

801072cc <vector141>:
801072cc:	6a 00                	push   $0x0
801072ce:	68 8d 00 00 00       	push   $0x8d
801072d3:	e9 95 f4 ff ff       	jmp    8010676d <alltraps>

801072d8 <vector142>:
801072d8:	6a 00                	push   $0x0
801072da:	68 8e 00 00 00       	push   $0x8e
801072df:	e9 89 f4 ff ff       	jmp    8010676d <alltraps>

801072e4 <vector143>:
801072e4:	6a 00                	push   $0x0
801072e6:	68 8f 00 00 00       	push   $0x8f
801072eb:	e9 7d f4 ff ff       	jmp    8010676d <alltraps>

801072f0 <vector144>:
801072f0:	6a 00                	push   $0x0
801072f2:	68 90 00 00 00       	push   $0x90
801072f7:	e9 71 f4 ff ff       	jmp    8010676d <alltraps>

801072fc <vector145>:
801072fc:	6a 00                	push   $0x0
801072fe:	68 91 00 00 00       	push   $0x91
80107303:	e9 65 f4 ff ff       	jmp    8010676d <alltraps>

80107308 <vector146>:
80107308:	6a 00                	push   $0x0
8010730a:	68 92 00 00 00       	push   $0x92
8010730f:	e9 59 f4 ff ff       	jmp    8010676d <alltraps>

80107314 <vector147>:
80107314:	6a 00                	push   $0x0
80107316:	68 93 00 00 00       	push   $0x93
8010731b:	e9 4d f4 ff ff       	jmp    8010676d <alltraps>

80107320 <vector148>:
80107320:	6a 00                	push   $0x0
80107322:	68 94 00 00 00       	push   $0x94
80107327:	e9 41 f4 ff ff       	jmp    8010676d <alltraps>

8010732c <vector149>:
8010732c:	6a 00                	push   $0x0
8010732e:	68 95 00 00 00       	push   $0x95
80107333:	e9 35 f4 ff ff       	jmp    8010676d <alltraps>

80107338 <vector150>:
80107338:	6a 00                	push   $0x0
8010733a:	68 96 00 00 00       	push   $0x96
8010733f:	e9 29 f4 ff ff       	jmp    8010676d <alltraps>

80107344 <vector151>:
80107344:	6a 00                	push   $0x0
80107346:	68 97 00 00 00       	push   $0x97
8010734b:	e9 1d f4 ff ff       	jmp    8010676d <alltraps>

80107350 <vector152>:
80107350:	6a 00                	push   $0x0
80107352:	68 98 00 00 00       	push   $0x98
80107357:	e9 11 f4 ff ff       	jmp    8010676d <alltraps>

8010735c <vector153>:
8010735c:	6a 00                	push   $0x0
8010735e:	68 99 00 00 00       	push   $0x99
80107363:	e9 05 f4 ff ff       	jmp    8010676d <alltraps>

80107368 <vector154>:
80107368:	6a 00                	push   $0x0
8010736a:	68 9a 00 00 00       	push   $0x9a
8010736f:	e9 f9 f3 ff ff       	jmp    8010676d <alltraps>

80107374 <vector155>:
80107374:	6a 00                	push   $0x0
80107376:	68 9b 00 00 00       	push   $0x9b
8010737b:	e9 ed f3 ff ff       	jmp    8010676d <alltraps>

80107380 <vector156>:
80107380:	6a 00                	push   $0x0
80107382:	68 9c 00 00 00       	push   $0x9c
80107387:	e9 e1 f3 ff ff       	jmp    8010676d <alltraps>

8010738c <vector157>:
8010738c:	6a 00                	push   $0x0
8010738e:	68 9d 00 00 00       	push   $0x9d
80107393:	e9 d5 f3 ff ff       	jmp    8010676d <alltraps>

80107398 <vector158>:
80107398:	6a 00                	push   $0x0
8010739a:	68 9e 00 00 00       	push   $0x9e
8010739f:	e9 c9 f3 ff ff       	jmp    8010676d <alltraps>

801073a4 <vector159>:
801073a4:	6a 00                	push   $0x0
801073a6:	68 9f 00 00 00       	push   $0x9f
801073ab:	e9 bd f3 ff ff       	jmp    8010676d <alltraps>

801073b0 <vector160>:
801073b0:	6a 00                	push   $0x0
801073b2:	68 a0 00 00 00       	push   $0xa0
801073b7:	e9 b1 f3 ff ff       	jmp    8010676d <alltraps>

801073bc <vector161>:
801073bc:	6a 00                	push   $0x0
801073be:	68 a1 00 00 00       	push   $0xa1
801073c3:	e9 a5 f3 ff ff       	jmp    8010676d <alltraps>

801073c8 <vector162>:
801073c8:	6a 00                	push   $0x0
801073ca:	68 a2 00 00 00       	push   $0xa2
801073cf:	e9 99 f3 ff ff       	jmp    8010676d <alltraps>

801073d4 <vector163>:
801073d4:	6a 00                	push   $0x0
801073d6:	68 a3 00 00 00       	push   $0xa3
801073db:	e9 8d f3 ff ff       	jmp    8010676d <alltraps>

801073e0 <vector164>:
801073e0:	6a 00                	push   $0x0
801073e2:	68 a4 00 00 00       	push   $0xa4
801073e7:	e9 81 f3 ff ff       	jmp    8010676d <alltraps>

801073ec <vector165>:
801073ec:	6a 00                	push   $0x0
801073ee:	68 a5 00 00 00       	push   $0xa5
801073f3:	e9 75 f3 ff ff       	jmp    8010676d <alltraps>

801073f8 <vector166>:
801073f8:	6a 00                	push   $0x0
801073fa:	68 a6 00 00 00       	push   $0xa6
801073ff:	e9 69 f3 ff ff       	jmp    8010676d <alltraps>

80107404 <vector167>:
80107404:	6a 00                	push   $0x0
80107406:	68 a7 00 00 00       	push   $0xa7
8010740b:	e9 5d f3 ff ff       	jmp    8010676d <alltraps>

80107410 <vector168>:
80107410:	6a 00                	push   $0x0
80107412:	68 a8 00 00 00       	push   $0xa8
80107417:	e9 51 f3 ff ff       	jmp    8010676d <alltraps>

8010741c <vector169>:
8010741c:	6a 00                	push   $0x0
8010741e:	68 a9 00 00 00       	push   $0xa9
80107423:	e9 45 f3 ff ff       	jmp    8010676d <alltraps>

80107428 <vector170>:
80107428:	6a 00                	push   $0x0
8010742a:	68 aa 00 00 00       	push   $0xaa
8010742f:	e9 39 f3 ff ff       	jmp    8010676d <alltraps>

80107434 <vector171>:
80107434:	6a 00                	push   $0x0
80107436:	68 ab 00 00 00       	push   $0xab
8010743b:	e9 2d f3 ff ff       	jmp    8010676d <alltraps>

80107440 <vector172>:
80107440:	6a 00                	push   $0x0
80107442:	68 ac 00 00 00       	push   $0xac
80107447:	e9 21 f3 ff ff       	jmp    8010676d <alltraps>

8010744c <vector173>:
8010744c:	6a 00                	push   $0x0
8010744e:	68 ad 00 00 00       	push   $0xad
80107453:	e9 15 f3 ff ff       	jmp    8010676d <alltraps>

80107458 <vector174>:
80107458:	6a 00                	push   $0x0
8010745a:	68 ae 00 00 00       	push   $0xae
8010745f:	e9 09 f3 ff ff       	jmp    8010676d <alltraps>

80107464 <vector175>:
80107464:	6a 00                	push   $0x0
80107466:	68 af 00 00 00       	push   $0xaf
8010746b:	e9 fd f2 ff ff       	jmp    8010676d <alltraps>

80107470 <vector176>:
80107470:	6a 00                	push   $0x0
80107472:	68 b0 00 00 00       	push   $0xb0
80107477:	e9 f1 f2 ff ff       	jmp    8010676d <alltraps>

8010747c <vector177>:
8010747c:	6a 00                	push   $0x0
8010747e:	68 b1 00 00 00       	push   $0xb1
80107483:	e9 e5 f2 ff ff       	jmp    8010676d <alltraps>

80107488 <vector178>:
80107488:	6a 00                	push   $0x0
8010748a:	68 b2 00 00 00       	push   $0xb2
8010748f:	e9 d9 f2 ff ff       	jmp    8010676d <alltraps>

80107494 <vector179>:
80107494:	6a 00                	push   $0x0
80107496:	68 b3 00 00 00       	push   $0xb3
8010749b:	e9 cd f2 ff ff       	jmp    8010676d <alltraps>

801074a0 <vector180>:
801074a0:	6a 00                	push   $0x0
801074a2:	68 b4 00 00 00       	push   $0xb4
801074a7:	e9 c1 f2 ff ff       	jmp    8010676d <alltraps>

801074ac <vector181>:
801074ac:	6a 00                	push   $0x0
801074ae:	68 b5 00 00 00       	push   $0xb5
801074b3:	e9 b5 f2 ff ff       	jmp    8010676d <alltraps>

801074b8 <vector182>:
801074b8:	6a 00                	push   $0x0
801074ba:	68 b6 00 00 00       	push   $0xb6
801074bf:	e9 a9 f2 ff ff       	jmp    8010676d <alltraps>

801074c4 <vector183>:
801074c4:	6a 00                	push   $0x0
801074c6:	68 b7 00 00 00       	push   $0xb7
801074cb:	e9 9d f2 ff ff       	jmp    8010676d <alltraps>

801074d0 <vector184>:
801074d0:	6a 00                	push   $0x0
801074d2:	68 b8 00 00 00       	push   $0xb8
801074d7:	e9 91 f2 ff ff       	jmp    8010676d <alltraps>

801074dc <vector185>:
801074dc:	6a 00                	push   $0x0
801074de:	68 b9 00 00 00       	push   $0xb9
801074e3:	e9 85 f2 ff ff       	jmp    8010676d <alltraps>

801074e8 <vector186>:
801074e8:	6a 00                	push   $0x0
801074ea:	68 ba 00 00 00       	push   $0xba
801074ef:	e9 79 f2 ff ff       	jmp    8010676d <alltraps>

801074f4 <vector187>:
801074f4:	6a 00                	push   $0x0
801074f6:	68 bb 00 00 00       	push   $0xbb
801074fb:	e9 6d f2 ff ff       	jmp    8010676d <alltraps>

80107500 <vector188>:
80107500:	6a 00                	push   $0x0
80107502:	68 bc 00 00 00       	push   $0xbc
80107507:	e9 61 f2 ff ff       	jmp    8010676d <alltraps>

8010750c <vector189>:
8010750c:	6a 00                	push   $0x0
8010750e:	68 bd 00 00 00       	push   $0xbd
80107513:	e9 55 f2 ff ff       	jmp    8010676d <alltraps>

80107518 <vector190>:
80107518:	6a 00                	push   $0x0
8010751a:	68 be 00 00 00       	push   $0xbe
8010751f:	e9 49 f2 ff ff       	jmp    8010676d <alltraps>

80107524 <vector191>:
80107524:	6a 00                	push   $0x0
80107526:	68 bf 00 00 00       	push   $0xbf
8010752b:	e9 3d f2 ff ff       	jmp    8010676d <alltraps>

80107530 <vector192>:
80107530:	6a 00                	push   $0x0
80107532:	68 c0 00 00 00       	push   $0xc0
80107537:	e9 31 f2 ff ff       	jmp    8010676d <alltraps>

8010753c <vector193>:
8010753c:	6a 00                	push   $0x0
8010753e:	68 c1 00 00 00       	push   $0xc1
80107543:	e9 25 f2 ff ff       	jmp    8010676d <alltraps>

80107548 <vector194>:
80107548:	6a 00                	push   $0x0
8010754a:	68 c2 00 00 00       	push   $0xc2
8010754f:	e9 19 f2 ff ff       	jmp    8010676d <alltraps>

80107554 <vector195>:
80107554:	6a 00                	push   $0x0
80107556:	68 c3 00 00 00       	push   $0xc3
8010755b:	e9 0d f2 ff ff       	jmp    8010676d <alltraps>

80107560 <vector196>:
80107560:	6a 00                	push   $0x0
80107562:	68 c4 00 00 00       	push   $0xc4
80107567:	e9 01 f2 ff ff       	jmp    8010676d <alltraps>

8010756c <vector197>:
8010756c:	6a 00                	push   $0x0
8010756e:	68 c5 00 00 00       	push   $0xc5
80107573:	e9 f5 f1 ff ff       	jmp    8010676d <alltraps>

80107578 <vector198>:
80107578:	6a 00                	push   $0x0
8010757a:	68 c6 00 00 00       	push   $0xc6
8010757f:	e9 e9 f1 ff ff       	jmp    8010676d <alltraps>

80107584 <vector199>:
80107584:	6a 00                	push   $0x0
80107586:	68 c7 00 00 00       	push   $0xc7
8010758b:	e9 dd f1 ff ff       	jmp    8010676d <alltraps>

80107590 <vector200>:
80107590:	6a 00                	push   $0x0
80107592:	68 c8 00 00 00       	push   $0xc8
80107597:	e9 d1 f1 ff ff       	jmp    8010676d <alltraps>

8010759c <vector201>:
8010759c:	6a 00                	push   $0x0
8010759e:	68 c9 00 00 00       	push   $0xc9
801075a3:	e9 c5 f1 ff ff       	jmp    8010676d <alltraps>

801075a8 <vector202>:
801075a8:	6a 00                	push   $0x0
801075aa:	68 ca 00 00 00       	push   $0xca
801075af:	e9 b9 f1 ff ff       	jmp    8010676d <alltraps>

801075b4 <vector203>:
801075b4:	6a 00                	push   $0x0
801075b6:	68 cb 00 00 00       	push   $0xcb
801075bb:	e9 ad f1 ff ff       	jmp    8010676d <alltraps>

801075c0 <vector204>:
801075c0:	6a 00                	push   $0x0
801075c2:	68 cc 00 00 00       	push   $0xcc
801075c7:	e9 a1 f1 ff ff       	jmp    8010676d <alltraps>

801075cc <vector205>:
801075cc:	6a 00                	push   $0x0
801075ce:	68 cd 00 00 00       	push   $0xcd
801075d3:	e9 95 f1 ff ff       	jmp    8010676d <alltraps>

801075d8 <vector206>:
801075d8:	6a 00                	push   $0x0
801075da:	68 ce 00 00 00       	push   $0xce
801075df:	e9 89 f1 ff ff       	jmp    8010676d <alltraps>

801075e4 <vector207>:
801075e4:	6a 00                	push   $0x0
801075e6:	68 cf 00 00 00       	push   $0xcf
801075eb:	e9 7d f1 ff ff       	jmp    8010676d <alltraps>

801075f0 <vector208>:
801075f0:	6a 00                	push   $0x0
801075f2:	68 d0 00 00 00       	push   $0xd0
801075f7:	e9 71 f1 ff ff       	jmp    8010676d <alltraps>

801075fc <vector209>:
801075fc:	6a 00                	push   $0x0
801075fe:	68 d1 00 00 00       	push   $0xd1
80107603:	e9 65 f1 ff ff       	jmp    8010676d <alltraps>

80107608 <vector210>:
80107608:	6a 00                	push   $0x0
8010760a:	68 d2 00 00 00       	push   $0xd2
8010760f:	e9 59 f1 ff ff       	jmp    8010676d <alltraps>

80107614 <vector211>:
80107614:	6a 00                	push   $0x0
80107616:	68 d3 00 00 00       	push   $0xd3
8010761b:	e9 4d f1 ff ff       	jmp    8010676d <alltraps>

80107620 <vector212>:
80107620:	6a 00                	push   $0x0
80107622:	68 d4 00 00 00       	push   $0xd4
80107627:	e9 41 f1 ff ff       	jmp    8010676d <alltraps>

8010762c <vector213>:
8010762c:	6a 00                	push   $0x0
8010762e:	68 d5 00 00 00       	push   $0xd5
80107633:	e9 35 f1 ff ff       	jmp    8010676d <alltraps>

80107638 <vector214>:
80107638:	6a 00                	push   $0x0
8010763a:	68 d6 00 00 00       	push   $0xd6
8010763f:	e9 29 f1 ff ff       	jmp    8010676d <alltraps>

80107644 <vector215>:
80107644:	6a 00                	push   $0x0
80107646:	68 d7 00 00 00       	push   $0xd7
8010764b:	e9 1d f1 ff ff       	jmp    8010676d <alltraps>

80107650 <vector216>:
80107650:	6a 00                	push   $0x0
80107652:	68 d8 00 00 00       	push   $0xd8
80107657:	e9 11 f1 ff ff       	jmp    8010676d <alltraps>

8010765c <vector217>:
8010765c:	6a 00                	push   $0x0
8010765e:	68 d9 00 00 00       	push   $0xd9
80107663:	e9 05 f1 ff ff       	jmp    8010676d <alltraps>

80107668 <vector218>:
80107668:	6a 00                	push   $0x0
8010766a:	68 da 00 00 00       	push   $0xda
8010766f:	e9 f9 f0 ff ff       	jmp    8010676d <alltraps>

80107674 <vector219>:
80107674:	6a 00                	push   $0x0
80107676:	68 db 00 00 00       	push   $0xdb
8010767b:	e9 ed f0 ff ff       	jmp    8010676d <alltraps>

80107680 <vector220>:
80107680:	6a 00                	push   $0x0
80107682:	68 dc 00 00 00       	push   $0xdc
80107687:	e9 e1 f0 ff ff       	jmp    8010676d <alltraps>

8010768c <vector221>:
8010768c:	6a 00                	push   $0x0
8010768e:	68 dd 00 00 00       	push   $0xdd
80107693:	e9 d5 f0 ff ff       	jmp    8010676d <alltraps>

80107698 <vector222>:
80107698:	6a 00                	push   $0x0
8010769a:	68 de 00 00 00       	push   $0xde
8010769f:	e9 c9 f0 ff ff       	jmp    8010676d <alltraps>

801076a4 <vector223>:
801076a4:	6a 00                	push   $0x0
801076a6:	68 df 00 00 00       	push   $0xdf
801076ab:	e9 bd f0 ff ff       	jmp    8010676d <alltraps>

801076b0 <vector224>:
801076b0:	6a 00                	push   $0x0
801076b2:	68 e0 00 00 00       	push   $0xe0
801076b7:	e9 b1 f0 ff ff       	jmp    8010676d <alltraps>

801076bc <vector225>:
801076bc:	6a 00                	push   $0x0
801076be:	68 e1 00 00 00       	push   $0xe1
801076c3:	e9 a5 f0 ff ff       	jmp    8010676d <alltraps>

801076c8 <vector226>:
801076c8:	6a 00                	push   $0x0
801076ca:	68 e2 00 00 00       	push   $0xe2
801076cf:	e9 99 f0 ff ff       	jmp    8010676d <alltraps>

801076d4 <vector227>:
801076d4:	6a 00                	push   $0x0
801076d6:	68 e3 00 00 00       	push   $0xe3
801076db:	e9 8d f0 ff ff       	jmp    8010676d <alltraps>

801076e0 <vector228>:
801076e0:	6a 00                	push   $0x0
801076e2:	68 e4 00 00 00       	push   $0xe4
801076e7:	e9 81 f0 ff ff       	jmp    8010676d <alltraps>

801076ec <vector229>:
801076ec:	6a 00                	push   $0x0
801076ee:	68 e5 00 00 00       	push   $0xe5
801076f3:	e9 75 f0 ff ff       	jmp    8010676d <alltraps>

801076f8 <vector230>:
801076f8:	6a 00                	push   $0x0
801076fa:	68 e6 00 00 00       	push   $0xe6
801076ff:	e9 69 f0 ff ff       	jmp    8010676d <alltraps>

80107704 <vector231>:
80107704:	6a 00                	push   $0x0
80107706:	68 e7 00 00 00       	push   $0xe7
8010770b:	e9 5d f0 ff ff       	jmp    8010676d <alltraps>

80107710 <vector232>:
80107710:	6a 00                	push   $0x0
80107712:	68 e8 00 00 00       	push   $0xe8
80107717:	e9 51 f0 ff ff       	jmp    8010676d <alltraps>

8010771c <vector233>:
8010771c:	6a 00                	push   $0x0
8010771e:	68 e9 00 00 00       	push   $0xe9
80107723:	e9 45 f0 ff ff       	jmp    8010676d <alltraps>

80107728 <vector234>:
80107728:	6a 00                	push   $0x0
8010772a:	68 ea 00 00 00       	push   $0xea
8010772f:	e9 39 f0 ff ff       	jmp    8010676d <alltraps>

80107734 <vector235>:
80107734:	6a 00                	push   $0x0
80107736:	68 eb 00 00 00       	push   $0xeb
8010773b:	e9 2d f0 ff ff       	jmp    8010676d <alltraps>

80107740 <vector236>:
80107740:	6a 00                	push   $0x0
80107742:	68 ec 00 00 00       	push   $0xec
80107747:	e9 21 f0 ff ff       	jmp    8010676d <alltraps>

8010774c <vector237>:
8010774c:	6a 00                	push   $0x0
8010774e:	68 ed 00 00 00       	push   $0xed
80107753:	e9 15 f0 ff ff       	jmp    8010676d <alltraps>

80107758 <vector238>:
80107758:	6a 00                	push   $0x0
8010775a:	68 ee 00 00 00       	push   $0xee
8010775f:	e9 09 f0 ff ff       	jmp    8010676d <alltraps>

80107764 <vector239>:
80107764:	6a 00                	push   $0x0
80107766:	68 ef 00 00 00       	push   $0xef
8010776b:	e9 fd ef ff ff       	jmp    8010676d <alltraps>

80107770 <vector240>:
80107770:	6a 00                	push   $0x0
80107772:	68 f0 00 00 00       	push   $0xf0
80107777:	e9 f1 ef ff ff       	jmp    8010676d <alltraps>

8010777c <vector241>:
8010777c:	6a 00                	push   $0x0
8010777e:	68 f1 00 00 00       	push   $0xf1
80107783:	e9 e5 ef ff ff       	jmp    8010676d <alltraps>

80107788 <vector242>:
80107788:	6a 00                	push   $0x0
8010778a:	68 f2 00 00 00       	push   $0xf2
8010778f:	e9 d9 ef ff ff       	jmp    8010676d <alltraps>

80107794 <vector243>:
80107794:	6a 00                	push   $0x0
80107796:	68 f3 00 00 00       	push   $0xf3
8010779b:	e9 cd ef ff ff       	jmp    8010676d <alltraps>

801077a0 <vector244>:
801077a0:	6a 00                	push   $0x0
801077a2:	68 f4 00 00 00       	push   $0xf4
801077a7:	e9 c1 ef ff ff       	jmp    8010676d <alltraps>

801077ac <vector245>:
801077ac:	6a 00                	push   $0x0
801077ae:	68 f5 00 00 00       	push   $0xf5
801077b3:	e9 b5 ef ff ff       	jmp    8010676d <alltraps>

801077b8 <vector246>:
801077b8:	6a 00                	push   $0x0
801077ba:	68 f6 00 00 00       	push   $0xf6
801077bf:	e9 a9 ef ff ff       	jmp    8010676d <alltraps>

801077c4 <vector247>:
801077c4:	6a 00                	push   $0x0
801077c6:	68 f7 00 00 00       	push   $0xf7
801077cb:	e9 9d ef ff ff       	jmp    8010676d <alltraps>

801077d0 <vector248>:
801077d0:	6a 00                	push   $0x0
801077d2:	68 f8 00 00 00       	push   $0xf8
801077d7:	e9 91 ef ff ff       	jmp    8010676d <alltraps>

801077dc <vector249>:
801077dc:	6a 00                	push   $0x0
801077de:	68 f9 00 00 00       	push   $0xf9
801077e3:	e9 85 ef ff ff       	jmp    8010676d <alltraps>

801077e8 <vector250>:
801077e8:	6a 00                	push   $0x0
801077ea:	68 fa 00 00 00       	push   $0xfa
801077ef:	e9 79 ef ff ff       	jmp    8010676d <alltraps>

801077f4 <vector251>:
801077f4:	6a 00                	push   $0x0
801077f6:	68 fb 00 00 00       	push   $0xfb
801077fb:	e9 6d ef ff ff       	jmp    8010676d <alltraps>

80107800 <vector252>:
80107800:	6a 00                	push   $0x0
80107802:	68 fc 00 00 00       	push   $0xfc
80107807:	e9 61 ef ff ff       	jmp    8010676d <alltraps>

8010780c <vector253>:
8010780c:	6a 00                	push   $0x0
8010780e:	68 fd 00 00 00       	push   $0xfd
80107813:	e9 55 ef ff ff       	jmp    8010676d <alltraps>

80107818 <vector254>:
80107818:	6a 00                	push   $0x0
8010781a:	68 fe 00 00 00       	push   $0xfe
8010781f:	e9 49 ef ff ff       	jmp    8010676d <alltraps>

80107824 <vector255>:
80107824:	6a 00                	push   $0x0
80107826:	68 ff 00 00 00       	push   $0xff
8010782b:	e9 3d ef ff ff       	jmp    8010676d <alltraps>

80107830 <lgdt>:
{
80107830:	55                   	push   %ebp
80107831:	89 e5                	mov    %esp,%ebp
80107833:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80107836:	8b 45 0c             	mov    0xc(%ebp),%eax
80107839:	83 e8 01             	sub    $0x1,%eax
8010783c:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107840:	8b 45 08             	mov    0x8(%ebp),%eax
80107843:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107847:	8b 45 08             	mov    0x8(%ebp),%eax
8010784a:	c1 e8 10             	shr    $0x10,%eax
8010784d:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80107851:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107854:	0f 01 10             	lgdtl  (%eax)
}
80107857:	90                   	nop
80107858:	c9                   	leave  
80107859:	c3                   	ret    

8010785a <ltr>:
{
8010785a:	55                   	push   %ebp
8010785b:	89 e5                	mov    %esp,%ebp
8010785d:	83 ec 04             	sub    $0x4,%esp
80107860:	8b 45 08             	mov    0x8(%ebp),%eax
80107863:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80107867:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
8010786b:	0f 00 d8             	ltr    %ax
}
8010786e:	90                   	nop
8010786f:	c9                   	leave  
80107870:	c3                   	ret    

80107871 <loadgs>:
{
80107871:	55                   	push   %ebp
80107872:	89 e5                	mov    %esp,%ebp
80107874:	83 ec 04             	sub    $0x4,%esp
80107877:	8b 45 08             	mov    0x8(%ebp),%eax
8010787a:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
8010787e:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107882:	8e e8                	mov    %eax,%gs
}
80107884:	90                   	nop
80107885:	c9                   	leave  
80107886:	c3                   	ret    

80107887 <lcr3>:

static inline void
lcr3(uint val) 
{
80107887:	55                   	push   %ebp
80107888:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010788a:	8b 45 08             	mov    0x8(%ebp),%eax
8010788d:	0f 22 d8             	mov    %eax,%cr3
}
80107890:	90                   	nop
80107891:	5d                   	pop    %ebp
80107892:	c3                   	ret    

80107893 <v2p>:
static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80107893:	55                   	push   %ebp
80107894:	89 e5                	mov    %esp,%ebp
80107896:	8b 45 08             	mov    0x8(%ebp),%eax
80107899:	05 00 00 00 80       	add    $0x80000000,%eax
8010789e:	5d                   	pop    %ebp
8010789f:	c3                   	ret    

801078a0 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
801078a0:	55                   	push   %ebp
801078a1:	89 e5                	mov    %esp,%ebp
801078a3:	8b 45 08             	mov    0x8(%ebp),%eax
801078a6:	05 00 00 00 80       	add    $0x80000000,%eax
801078ab:	5d                   	pop    %ebp
801078ac:	c3                   	ret    

801078ad <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
801078ad:	55                   	push   %ebp
801078ae:	89 e5                	mov    %esp,%ebp
801078b0:	53                   	push   %ebx
801078b1:	83 ec 14             	sub    $0x14,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
801078b4:	e8 13 b7 ff ff       	call   80102fcc <cpunum>
801078b9:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
801078bf:	05 60 23 11 80       	add    $0x80112360,%eax
801078c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801078c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078ca:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
801078d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078d3:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
801078d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078dc:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
801078e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078e3:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801078e7:	83 e2 f0             	and    $0xfffffff0,%edx
801078ea:	83 ca 0a             	or     $0xa,%edx
801078ed:	88 50 7d             	mov    %dl,0x7d(%eax)
801078f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078f3:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801078f7:	83 ca 10             	or     $0x10,%edx
801078fa:	88 50 7d             	mov    %dl,0x7d(%eax)
801078fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107900:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107904:	83 e2 9f             	and    $0xffffff9f,%edx
80107907:	88 50 7d             	mov    %dl,0x7d(%eax)
8010790a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010790d:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107911:	83 ca 80             	or     $0xffffff80,%edx
80107914:	88 50 7d             	mov    %dl,0x7d(%eax)
80107917:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010791a:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010791e:	83 ca 0f             	or     $0xf,%edx
80107921:	88 50 7e             	mov    %dl,0x7e(%eax)
80107924:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107927:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010792b:	83 e2 ef             	and    $0xffffffef,%edx
8010792e:	88 50 7e             	mov    %dl,0x7e(%eax)
80107931:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107934:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107938:	83 e2 df             	and    $0xffffffdf,%edx
8010793b:	88 50 7e             	mov    %dl,0x7e(%eax)
8010793e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107941:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107945:	83 ca 40             	or     $0x40,%edx
80107948:	88 50 7e             	mov    %dl,0x7e(%eax)
8010794b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010794e:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107952:	83 ca 80             	or     $0xffffff80,%edx
80107955:	88 50 7e             	mov    %dl,0x7e(%eax)
80107958:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010795b:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010795f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107962:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80107969:	ff ff 
8010796b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010796e:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80107975:	00 00 
80107977:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010797a:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80107981:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107984:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
8010798b:	83 e2 f0             	and    $0xfffffff0,%edx
8010798e:	83 ca 02             	or     $0x2,%edx
80107991:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107997:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010799a:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801079a1:	83 ca 10             	or     $0x10,%edx
801079a4:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801079aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079ad:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801079b4:	83 e2 9f             	and    $0xffffff9f,%edx
801079b7:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801079bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079c0:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801079c7:	83 ca 80             	or     $0xffffff80,%edx
801079ca:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801079d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079d3:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801079da:	83 ca 0f             	or     $0xf,%edx
801079dd:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801079e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079e6:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801079ed:	83 e2 ef             	and    $0xffffffef,%edx
801079f0:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801079f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079f9:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107a00:	83 e2 df             	and    $0xffffffdf,%edx
80107a03:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107a09:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a0c:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107a13:	83 ca 40             	or     $0x40,%edx
80107a16:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107a1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a1f:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107a26:	83 ca 80             	or     $0xffffff80,%edx
80107a29:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107a2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a32:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107a39:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a3c:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80107a43:	ff ff 
80107a45:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a48:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80107a4f:	00 00 
80107a51:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a54:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80107a5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a5e:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107a65:	83 e2 f0             	and    $0xfffffff0,%edx
80107a68:	83 ca 0a             	or     $0xa,%edx
80107a6b:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107a71:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a74:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107a7b:	83 ca 10             	or     $0x10,%edx
80107a7e:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107a84:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a87:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107a8e:	83 ca 60             	or     $0x60,%edx
80107a91:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107a97:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a9a:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107aa1:	83 ca 80             	or     $0xffffff80,%edx
80107aa4:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107aaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107aad:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107ab4:	83 ca 0f             	or     $0xf,%edx
80107ab7:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107abd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ac0:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107ac7:	83 e2 ef             	and    $0xffffffef,%edx
80107aca:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107ad0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ad3:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107ada:	83 e2 df             	and    $0xffffffdf,%edx
80107add:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107ae3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ae6:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107aed:	83 ca 40             	or     $0x40,%edx
80107af0:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107af6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107af9:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107b00:	83 ca 80             	or     $0xffffff80,%edx
80107b03:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107b09:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b0c:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107b13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b16:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
80107b1d:	ff ff 
80107b1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b22:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
80107b29:	00 00 
80107b2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b2e:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
80107b35:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b38:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107b3f:	83 e2 f0             	and    $0xfffffff0,%edx
80107b42:	83 ca 02             	or     $0x2,%edx
80107b45:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107b4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b4e:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107b55:	83 ca 10             	or     $0x10,%edx
80107b58:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107b5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b61:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107b68:	83 ca 60             	or     $0x60,%edx
80107b6b:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107b71:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b74:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107b7b:	83 ca 80             	or     $0xffffff80,%edx
80107b7e:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107b84:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b87:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107b8e:	83 ca 0f             	or     $0xf,%edx
80107b91:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107b97:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b9a:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107ba1:	83 e2 ef             	and    $0xffffffef,%edx
80107ba4:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107baa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bad:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107bb4:	83 e2 df             	and    $0xffffffdf,%edx
80107bb7:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107bbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bc0:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107bc7:	83 ca 40             	or     $0x40,%edx
80107bca:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107bd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bd3:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107bda:	83 ca 80             	or     $0xffffff80,%edx
80107bdd:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107be3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107be6:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80107bed:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bf0:	05 b4 00 00 00       	add    $0xb4,%eax
80107bf5:	89 c3                	mov    %eax,%ebx
80107bf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bfa:	05 b4 00 00 00       	add    $0xb4,%eax
80107bff:	c1 e8 10             	shr    $0x10,%eax
80107c02:	89 c2                	mov    %eax,%edx
80107c04:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c07:	05 b4 00 00 00       	add    $0xb4,%eax
80107c0c:	c1 e8 18             	shr    $0x18,%eax
80107c0f:	89 c1                	mov    %eax,%ecx
80107c11:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c14:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
80107c1b:	00 00 
80107c1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c20:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
80107c27:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c2a:	88 90 8c 00 00 00    	mov    %dl,0x8c(%eax)
80107c30:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c33:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107c3a:	83 e2 f0             	and    $0xfffffff0,%edx
80107c3d:	83 ca 02             	or     $0x2,%edx
80107c40:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107c46:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c49:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107c50:	83 ca 10             	or     $0x10,%edx
80107c53:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107c59:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c5c:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107c63:	83 e2 9f             	and    $0xffffff9f,%edx
80107c66:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107c6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c6f:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107c76:	83 ca 80             	or     $0xffffff80,%edx
80107c79:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107c7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c82:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107c89:	83 e2 f0             	and    $0xfffffff0,%edx
80107c8c:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107c92:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c95:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107c9c:	83 e2 ef             	and    $0xffffffef,%edx
80107c9f:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107ca5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ca8:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107caf:	83 e2 df             	and    $0xffffffdf,%edx
80107cb2:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107cb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cbb:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107cc2:	83 ca 40             	or     $0x40,%edx
80107cc5:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107ccb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cce:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107cd5:	83 ca 80             	or     $0xffffff80,%edx
80107cd8:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107cde:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ce1:	88 88 8f 00 00 00    	mov    %cl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80107ce7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cea:	83 c0 70             	add    $0x70,%eax
80107ced:	83 ec 08             	sub    $0x8,%esp
80107cf0:	6a 38                	push   $0x38
80107cf2:	50                   	push   %eax
80107cf3:	e8 38 fb ff ff       	call   80107830 <lgdt>
80107cf8:	83 c4 10             	add    $0x10,%esp
  loadgs(SEG_KCPU << 3);
80107cfb:	83 ec 0c             	sub    $0xc,%esp
80107cfe:	6a 18                	push   $0x18
80107d00:	e8 6c fb ff ff       	call   80107871 <loadgs>
80107d05:	83 c4 10             	add    $0x10,%esp
  
  // Initialize cpu-local storage.
  cpu = c;
80107d08:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d0b:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
80107d11:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80107d18:	00 00 00 00 
}
80107d1c:	90                   	nop
80107d1d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107d20:	c9                   	leave  
80107d21:	c3                   	ret    

80107d22 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107d22:	55                   	push   %ebp
80107d23:	89 e5                	mov    %esp,%ebp
80107d25:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107d28:	8b 45 0c             	mov    0xc(%ebp),%eax
80107d2b:	c1 e8 16             	shr    $0x16,%eax
80107d2e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107d35:	8b 45 08             	mov    0x8(%ebp),%eax
80107d38:	01 d0                	add    %edx,%eax
80107d3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
80107d3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107d40:	8b 00                	mov    (%eax),%eax
80107d42:	83 e0 01             	and    $0x1,%eax
80107d45:	85 c0                	test   %eax,%eax
80107d47:	74 18                	je     80107d61 <walkpgdir+0x3f>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
80107d49:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107d4c:	8b 00                	mov    (%eax),%eax
80107d4e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107d53:	50                   	push   %eax
80107d54:	e8 47 fb ff ff       	call   801078a0 <p2v>
80107d59:	83 c4 04             	add    $0x4,%esp
80107d5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107d5f:	eb 48                	jmp    80107da9 <walkpgdir+0x87>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107d61:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80107d65:	74 0e                	je     80107d75 <walkpgdir+0x53>
80107d67:	e8 fa ae ff ff       	call   80102c66 <kalloc>
80107d6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107d6f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107d73:	75 07                	jne    80107d7c <walkpgdir+0x5a>
      return 0;
80107d75:	b8 00 00 00 00       	mov    $0x0,%eax
80107d7a:	eb 44                	jmp    80107dc0 <walkpgdir+0x9e>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80107d7c:	83 ec 04             	sub    $0x4,%esp
80107d7f:	68 00 10 00 00       	push   $0x1000
80107d84:	6a 00                	push   $0x0
80107d86:	ff 75 f4             	pushl  -0xc(%ebp)
80107d89:	e8 0a d6 ff ff       	call   80105398 <memset>
80107d8e:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
80107d91:	83 ec 0c             	sub    $0xc,%esp
80107d94:	ff 75 f4             	pushl  -0xc(%ebp)
80107d97:	e8 f7 fa ff ff       	call   80107893 <v2p>
80107d9c:	83 c4 10             	add    $0x10,%esp
80107d9f:	83 c8 07             	or     $0x7,%eax
80107da2:	89 c2                	mov    %eax,%edx
80107da4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107da7:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
80107da9:	8b 45 0c             	mov    0xc(%ebp),%eax
80107dac:	c1 e8 0c             	shr    $0xc,%eax
80107daf:	25 ff 03 00 00       	and    $0x3ff,%eax
80107db4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107dbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dbe:	01 d0                	add    %edx,%eax
}
80107dc0:	c9                   	leave  
80107dc1:	c3                   	ret    

80107dc2 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107dc2:	55                   	push   %ebp
80107dc3:	89 e5                	mov    %esp,%ebp
80107dc5:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
80107dc8:	8b 45 0c             	mov    0xc(%ebp),%eax
80107dcb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107dd0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107dd3:	8b 55 0c             	mov    0xc(%ebp),%edx
80107dd6:	8b 45 10             	mov    0x10(%ebp),%eax
80107dd9:	01 d0                	add    %edx,%eax
80107ddb:	83 e8 01             	sub    $0x1,%eax
80107dde:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107de3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107de6:	83 ec 04             	sub    $0x4,%esp
80107de9:	6a 01                	push   $0x1
80107deb:	ff 75 f4             	pushl  -0xc(%ebp)
80107dee:	ff 75 08             	pushl  0x8(%ebp)
80107df1:	e8 2c ff ff ff       	call   80107d22 <walkpgdir>
80107df6:	83 c4 10             	add    $0x10,%esp
80107df9:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107dfc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107e00:	75 07                	jne    80107e09 <mappages+0x47>
      return -1;
80107e02:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107e07:	eb 47                	jmp    80107e50 <mappages+0x8e>
    if(*pte & PTE_P)
80107e09:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107e0c:	8b 00                	mov    (%eax),%eax
80107e0e:	83 e0 01             	and    $0x1,%eax
80107e11:	85 c0                	test   %eax,%eax
80107e13:	74 0d                	je     80107e22 <mappages+0x60>
      panic("remap");
80107e15:	83 ec 0c             	sub    $0xc,%esp
80107e18:	68 b4 8c 10 80       	push   $0x80108cb4
80107e1d:	e8 44 87 ff ff       	call   80100566 <panic>
    *pte = pa | perm | PTE_P;
80107e22:	8b 45 18             	mov    0x18(%ebp),%eax
80107e25:	0b 45 14             	or     0x14(%ebp),%eax
80107e28:	83 c8 01             	or     $0x1,%eax
80107e2b:	89 c2                	mov    %eax,%edx
80107e2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107e30:	89 10                	mov    %edx,(%eax)
    if(a == last)
80107e32:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e35:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80107e38:	74 10                	je     80107e4a <mappages+0x88>
      break;
    a += PGSIZE;
80107e3a:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
80107e41:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107e48:	eb 9c                	jmp    80107de6 <mappages+0x24>
      break;
80107e4a:	90                   	nop
  }
  return 0;
80107e4b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107e50:	c9                   	leave  
80107e51:	c3                   	ret    

80107e52 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80107e52:	55                   	push   %ebp
80107e53:	89 e5                	mov    %esp,%ebp
80107e55:	53                   	push   %ebx
80107e56:	83 ec 14             	sub    $0x14,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80107e59:	e8 08 ae ff ff       	call   80102c66 <kalloc>
80107e5e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107e61:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107e65:	75 0a                	jne    80107e71 <setupkvm+0x1f>
    return 0;
80107e67:	b8 00 00 00 00       	mov    $0x0,%eax
80107e6c:	e9 8e 00 00 00       	jmp    80107eff <setupkvm+0xad>
  memset(pgdir, 0, PGSIZE);
80107e71:	83 ec 04             	sub    $0x4,%esp
80107e74:	68 00 10 00 00       	push   $0x1000
80107e79:	6a 00                	push   $0x0
80107e7b:	ff 75 f0             	pushl  -0x10(%ebp)
80107e7e:	e8 15 d5 ff ff       	call   80105398 <memset>
80107e83:	83 c4 10             	add    $0x10,%esp
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
80107e86:	83 ec 0c             	sub    $0xc,%esp
80107e89:	68 00 00 00 0e       	push   $0xe000000
80107e8e:	e8 0d fa ff ff       	call   801078a0 <p2v>
80107e93:	83 c4 10             	add    $0x10,%esp
80107e96:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
80107e9b:	76 0d                	jbe    80107eaa <setupkvm+0x58>
    panic("PHYSTOP too high");
80107e9d:	83 ec 0c             	sub    $0xc,%esp
80107ea0:	68 ba 8c 10 80       	push   $0x80108cba
80107ea5:	e8 bc 86 ff ff       	call   80100566 <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107eaa:	c7 45 f4 a0 b4 10 80 	movl   $0x8010b4a0,-0xc(%ebp)
80107eb1:	eb 40                	jmp    80107ef3 <setupkvm+0xa1>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80107eb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107eb6:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0)
80107eb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ebc:	8b 50 04             	mov    0x4(%eax),%edx
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80107ebf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ec2:	8b 58 08             	mov    0x8(%eax),%ebx
80107ec5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ec8:	8b 40 04             	mov    0x4(%eax),%eax
80107ecb:	29 c3                	sub    %eax,%ebx
80107ecd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ed0:	8b 00                	mov    (%eax),%eax
80107ed2:	83 ec 0c             	sub    $0xc,%esp
80107ed5:	51                   	push   %ecx
80107ed6:	52                   	push   %edx
80107ed7:	53                   	push   %ebx
80107ed8:	50                   	push   %eax
80107ed9:	ff 75 f0             	pushl  -0x10(%ebp)
80107edc:	e8 e1 fe ff ff       	call   80107dc2 <mappages>
80107ee1:	83 c4 20             	add    $0x20,%esp
80107ee4:	85 c0                	test   %eax,%eax
80107ee6:	79 07                	jns    80107eef <setupkvm+0x9d>
      return 0;
80107ee8:	b8 00 00 00 00       	mov    $0x0,%eax
80107eed:	eb 10                	jmp    80107eff <setupkvm+0xad>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107eef:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80107ef3:	81 7d f4 e0 b4 10 80 	cmpl   $0x8010b4e0,-0xc(%ebp)
80107efa:	72 b7                	jb     80107eb3 <setupkvm+0x61>
  return pgdir;
80107efc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80107eff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107f02:	c9                   	leave  
80107f03:	c3                   	ret    

80107f04 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80107f04:	55                   	push   %ebp
80107f05:	89 e5                	mov    %esp,%ebp
80107f07:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107f0a:	e8 43 ff ff ff       	call   80107e52 <setupkvm>
80107f0f:	a3 38 52 11 80       	mov    %eax,0x80115238
  switchkvm();
80107f14:	e8 03 00 00 00       	call   80107f1c <switchkvm>
}
80107f19:	90                   	nop
80107f1a:	c9                   	leave  
80107f1b:	c3                   	ret    

80107f1c <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80107f1c:	55                   	push   %ebp
80107f1d:	89 e5                	mov    %esp,%ebp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
80107f1f:	a1 38 52 11 80       	mov    0x80115238,%eax
80107f24:	50                   	push   %eax
80107f25:	e8 69 f9 ff ff       	call   80107893 <v2p>
80107f2a:	83 c4 04             	add    $0x4,%esp
80107f2d:	50                   	push   %eax
80107f2e:	e8 54 f9 ff ff       	call   80107887 <lcr3>
80107f33:	83 c4 04             	add    $0x4,%esp
}
80107f36:	90                   	nop
80107f37:	c9                   	leave  
80107f38:	c3                   	ret    

80107f39 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80107f39:	55                   	push   %ebp
80107f3a:	89 e5                	mov    %esp,%ebp
80107f3c:	56                   	push   %esi
80107f3d:	53                   	push   %ebx
  pushcli();
80107f3e:	e8 4f d3 ff ff       	call   80105292 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80107f43:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107f49:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107f50:	83 c2 08             	add    $0x8,%edx
80107f53:	89 d6                	mov    %edx,%esi
80107f55:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107f5c:	83 c2 08             	add    $0x8,%edx
80107f5f:	c1 ea 10             	shr    $0x10,%edx
80107f62:	89 d3                	mov    %edx,%ebx
80107f64:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107f6b:	83 c2 08             	add    $0x8,%edx
80107f6e:	c1 ea 18             	shr    $0x18,%edx
80107f71:	89 d1                	mov    %edx,%ecx
80107f73:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
80107f7a:	67 00 
80107f7c:	66 89 b0 a2 00 00 00 	mov    %si,0xa2(%eax)
80107f83:	88 98 a4 00 00 00    	mov    %bl,0xa4(%eax)
80107f89:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80107f90:	83 e2 f0             	and    $0xfffffff0,%edx
80107f93:	83 ca 09             	or     $0x9,%edx
80107f96:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80107f9c:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80107fa3:	83 ca 10             	or     $0x10,%edx
80107fa6:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80107fac:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80107fb3:	83 e2 9f             	and    $0xffffff9f,%edx
80107fb6:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80107fbc:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80107fc3:	83 ca 80             	or     $0xffffff80,%edx
80107fc6:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80107fcc:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80107fd3:	83 e2 f0             	and    $0xfffffff0,%edx
80107fd6:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80107fdc:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80107fe3:	83 e2 ef             	and    $0xffffffef,%edx
80107fe6:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80107fec:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80107ff3:	83 e2 df             	and    $0xffffffdf,%edx
80107ff6:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80107ffc:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80108003:	83 ca 40             	or     $0x40,%edx
80108006:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
8010800c:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80108013:	83 e2 7f             	and    $0x7f,%edx
80108016:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
8010801c:	88 88 a7 00 00 00    	mov    %cl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
80108022:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108028:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
8010802f:	83 e2 ef             	and    $0xffffffef,%edx
80108032:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
80108038:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010803e:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80108044:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010804a:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80108051:	8b 52 08             	mov    0x8(%edx),%edx
80108054:	81 c2 00 10 00 00    	add    $0x1000,%edx
8010805a:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
8010805d:	83 ec 0c             	sub    $0xc,%esp
80108060:	6a 30                	push   $0x30
80108062:	e8 f3 f7 ff ff       	call   8010785a <ltr>
80108067:	83 c4 10             	add    $0x10,%esp
  if(p->pgdir == 0)
8010806a:	8b 45 08             	mov    0x8(%ebp),%eax
8010806d:	8b 40 04             	mov    0x4(%eax),%eax
80108070:	85 c0                	test   %eax,%eax
80108072:	75 0d                	jne    80108081 <switchuvm+0x148>
    panic("switchuvm: no pgdir");
80108074:	83 ec 0c             	sub    $0xc,%esp
80108077:	68 cb 8c 10 80       	push   $0x80108ccb
8010807c:	e8 e5 84 ff ff       	call   80100566 <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
80108081:	8b 45 08             	mov    0x8(%ebp),%eax
80108084:	8b 40 04             	mov    0x4(%eax),%eax
80108087:	83 ec 0c             	sub    $0xc,%esp
8010808a:	50                   	push   %eax
8010808b:	e8 03 f8 ff ff       	call   80107893 <v2p>
80108090:	83 c4 10             	add    $0x10,%esp
80108093:	83 ec 0c             	sub    $0xc,%esp
80108096:	50                   	push   %eax
80108097:	e8 eb f7 ff ff       	call   80107887 <lcr3>
8010809c:	83 c4 10             	add    $0x10,%esp
  popcli();
8010809f:	e8 33 d2 ff ff       	call   801052d7 <popcli>
}
801080a4:	90                   	nop
801080a5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801080a8:	5b                   	pop    %ebx
801080a9:	5e                   	pop    %esi
801080aa:	5d                   	pop    %ebp
801080ab:	c3                   	ret    

801080ac <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801080ac:	55                   	push   %ebp
801080ad:	89 e5                	mov    %esp,%ebp
801080af:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  
  if(sz >= PGSIZE)
801080b2:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
801080b9:	76 0d                	jbe    801080c8 <inituvm+0x1c>
    panic("inituvm: more than a page");
801080bb:	83 ec 0c             	sub    $0xc,%esp
801080be:	68 df 8c 10 80       	push   $0x80108cdf
801080c3:	e8 9e 84 ff ff       	call   80100566 <panic>
  mem = kalloc();
801080c8:	e8 99 ab ff ff       	call   80102c66 <kalloc>
801080cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
801080d0:	83 ec 04             	sub    $0x4,%esp
801080d3:	68 00 10 00 00       	push   $0x1000
801080d8:	6a 00                	push   $0x0
801080da:	ff 75 f4             	pushl  -0xc(%ebp)
801080dd:	e8 b6 d2 ff ff       	call   80105398 <memset>
801080e2:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
801080e5:	83 ec 0c             	sub    $0xc,%esp
801080e8:	ff 75 f4             	pushl  -0xc(%ebp)
801080eb:	e8 a3 f7 ff ff       	call   80107893 <v2p>
801080f0:	83 c4 10             	add    $0x10,%esp
801080f3:	83 ec 0c             	sub    $0xc,%esp
801080f6:	6a 06                	push   $0x6
801080f8:	50                   	push   %eax
801080f9:	68 00 10 00 00       	push   $0x1000
801080fe:	6a 00                	push   $0x0
80108100:	ff 75 08             	pushl  0x8(%ebp)
80108103:	e8 ba fc ff ff       	call   80107dc2 <mappages>
80108108:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
8010810b:	83 ec 04             	sub    $0x4,%esp
8010810e:	ff 75 10             	pushl  0x10(%ebp)
80108111:	ff 75 0c             	pushl  0xc(%ebp)
80108114:	ff 75 f4             	pushl  -0xc(%ebp)
80108117:	e8 3b d3 ff ff       	call   80105457 <memmove>
8010811c:	83 c4 10             	add    $0x10,%esp
}
8010811f:	90                   	nop
80108120:	c9                   	leave  
80108121:	c3                   	ret    

80108122 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80108122:	55                   	push   %ebp
80108123:	89 e5                	mov    %esp,%ebp
80108125:	53                   	push   %ebx
80108126:	83 ec 14             	sub    $0x14,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80108129:	8b 45 0c             	mov    0xc(%ebp),%eax
8010812c:	25 ff 0f 00 00       	and    $0xfff,%eax
80108131:	85 c0                	test   %eax,%eax
80108133:	74 0d                	je     80108142 <loaduvm+0x20>
    panic("loaduvm: addr must be page aligned");
80108135:	83 ec 0c             	sub    $0xc,%esp
80108138:	68 fc 8c 10 80       	push   $0x80108cfc
8010813d:	e8 24 84 ff ff       	call   80100566 <panic>
  for(i = 0; i < sz; i += PGSIZE){
80108142:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108149:	e9 95 00 00 00       	jmp    801081e3 <loaduvm+0xc1>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
8010814e:	8b 55 0c             	mov    0xc(%ebp),%edx
80108151:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108154:	01 d0                	add    %edx,%eax
80108156:	83 ec 04             	sub    $0x4,%esp
80108159:	6a 00                	push   $0x0
8010815b:	50                   	push   %eax
8010815c:	ff 75 08             	pushl  0x8(%ebp)
8010815f:	e8 be fb ff ff       	call   80107d22 <walkpgdir>
80108164:	83 c4 10             	add    $0x10,%esp
80108167:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010816a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010816e:	75 0d                	jne    8010817d <loaduvm+0x5b>
      panic("loaduvm: address should exist");
80108170:	83 ec 0c             	sub    $0xc,%esp
80108173:	68 1f 8d 10 80       	push   $0x80108d1f
80108178:	e8 e9 83 ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
8010817d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108180:	8b 00                	mov    (%eax),%eax
80108182:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108187:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
8010818a:	8b 45 18             	mov    0x18(%ebp),%eax
8010818d:	2b 45 f4             	sub    -0xc(%ebp),%eax
80108190:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80108195:	77 0b                	ja     801081a2 <loaduvm+0x80>
      n = sz - i;
80108197:	8b 45 18             	mov    0x18(%ebp),%eax
8010819a:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010819d:	89 45 f0             	mov    %eax,-0x10(%ebp)
801081a0:	eb 07                	jmp    801081a9 <loaduvm+0x87>
    else
      n = PGSIZE;
801081a2:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
801081a9:	8b 55 14             	mov    0x14(%ebp),%edx
801081ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081af:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
801081b2:	83 ec 0c             	sub    $0xc,%esp
801081b5:	ff 75 e8             	pushl  -0x18(%ebp)
801081b8:	e8 e3 f6 ff ff       	call   801078a0 <p2v>
801081bd:	83 c4 10             	add    $0x10,%esp
801081c0:	ff 75 f0             	pushl  -0x10(%ebp)
801081c3:	53                   	push   %ebx
801081c4:	50                   	push   %eax
801081c5:	ff 75 10             	pushl  0x10(%ebp)
801081c8:	e8 0b 9d ff ff       	call   80101ed8 <readi>
801081cd:	83 c4 10             	add    $0x10,%esp
801081d0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801081d3:	74 07                	je     801081dc <loaduvm+0xba>
      return -1;
801081d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801081da:	eb 18                	jmp    801081f4 <loaduvm+0xd2>
  for(i = 0; i < sz; i += PGSIZE){
801081dc:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801081e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081e6:	3b 45 18             	cmp    0x18(%ebp),%eax
801081e9:	0f 82 5f ff ff ff    	jb     8010814e <loaduvm+0x2c>
  }
  return 0;
801081ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
801081f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801081f7:	c9                   	leave  
801081f8:	c3                   	ret    

801081f9 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801081f9:	55                   	push   %ebp
801081fa:	89 e5                	mov    %esp,%ebp
801081fc:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
801081ff:	8b 45 10             	mov    0x10(%ebp),%eax
80108202:	85 c0                	test   %eax,%eax
80108204:	79 0a                	jns    80108210 <allocuvm+0x17>
    return 0;
80108206:	b8 00 00 00 00       	mov    $0x0,%eax
8010820b:	e9 b0 00 00 00       	jmp    801082c0 <allocuvm+0xc7>
  if(newsz < oldsz)
80108210:	8b 45 10             	mov    0x10(%ebp),%eax
80108213:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108216:	73 08                	jae    80108220 <allocuvm+0x27>
    return oldsz;
80108218:	8b 45 0c             	mov    0xc(%ebp),%eax
8010821b:	e9 a0 00 00 00       	jmp    801082c0 <allocuvm+0xc7>

  a = PGROUNDUP(oldsz);
80108220:	8b 45 0c             	mov    0xc(%ebp),%eax
80108223:	05 ff 0f 00 00       	add    $0xfff,%eax
80108228:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010822d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80108230:	eb 7f                	jmp    801082b1 <allocuvm+0xb8>
    mem = kalloc();
80108232:	e8 2f aa ff ff       	call   80102c66 <kalloc>
80108237:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
8010823a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010823e:	75 2b                	jne    8010826b <allocuvm+0x72>
      cprintf("allocuvm out of memory\n");
80108240:	83 ec 0c             	sub    $0xc,%esp
80108243:	68 3d 8d 10 80       	push   $0x80108d3d
80108248:	e8 79 81 ff ff       	call   801003c6 <cprintf>
8010824d:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
80108250:	83 ec 04             	sub    $0x4,%esp
80108253:	ff 75 0c             	pushl  0xc(%ebp)
80108256:	ff 75 10             	pushl  0x10(%ebp)
80108259:	ff 75 08             	pushl  0x8(%ebp)
8010825c:	e8 61 00 00 00       	call   801082c2 <deallocuvm>
80108261:	83 c4 10             	add    $0x10,%esp
      return 0;
80108264:	b8 00 00 00 00       	mov    $0x0,%eax
80108269:	eb 55                	jmp    801082c0 <allocuvm+0xc7>
    }
    memset(mem, 0, PGSIZE);
8010826b:	83 ec 04             	sub    $0x4,%esp
8010826e:	68 00 10 00 00       	push   $0x1000
80108273:	6a 00                	push   $0x0
80108275:	ff 75 f0             	pushl  -0x10(%ebp)
80108278:	e8 1b d1 ff ff       	call   80105398 <memset>
8010827d:	83 c4 10             	add    $0x10,%esp
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
80108280:	83 ec 0c             	sub    $0xc,%esp
80108283:	ff 75 f0             	pushl  -0x10(%ebp)
80108286:	e8 08 f6 ff ff       	call   80107893 <v2p>
8010828b:	83 c4 10             	add    $0x10,%esp
8010828e:	89 c2                	mov    %eax,%edx
80108290:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108293:	83 ec 0c             	sub    $0xc,%esp
80108296:	6a 06                	push   $0x6
80108298:	52                   	push   %edx
80108299:	68 00 10 00 00       	push   $0x1000
8010829e:	50                   	push   %eax
8010829f:	ff 75 08             	pushl  0x8(%ebp)
801082a2:	e8 1b fb ff ff       	call   80107dc2 <mappages>
801082a7:	83 c4 20             	add    $0x20,%esp
  for(; a < newsz; a += PGSIZE){
801082aa:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801082b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082b4:	3b 45 10             	cmp    0x10(%ebp),%eax
801082b7:	0f 82 75 ff ff ff    	jb     80108232 <allocuvm+0x39>
  }
  return newsz;
801082bd:	8b 45 10             	mov    0x10(%ebp),%eax
}
801082c0:	c9                   	leave  
801082c1:	c3                   	ret    

801082c2 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801082c2:	55                   	push   %ebp
801082c3:	89 e5                	mov    %esp,%ebp
801082c5:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
801082c8:	8b 45 10             	mov    0x10(%ebp),%eax
801082cb:	3b 45 0c             	cmp    0xc(%ebp),%eax
801082ce:	72 08                	jb     801082d8 <deallocuvm+0x16>
    return oldsz;
801082d0:	8b 45 0c             	mov    0xc(%ebp),%eax
801082d3:	e9 a5 00 00 00       	jmp    8010837d <deallocuvm+0xbb>

  a = PGROUNDUP(newsz);
801082d8:	8b 45 10             	mov    0x10(%ebp),%eax
801082db:	05 ff 0f 00 00       	add    $0xfff,%eax
801082e0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801082e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801082e8:	e9 81 00 00 00       	jmp    8010836e <deallocuvm+0xac>
    pte = walkpgdir(pgdir, (char*)a, 0);
801082ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082f0:	83 ec 04             	sub    $0x4,%esp
801082f3:	6a 00                	push   $0x0
801082f5:	50                   	push   %eax
801082f6:	ff 75 08             	pushl  0x8(%ebp)
801082f9:	e8 24 fa ff ff       	call   80107d22 <walkpgdir>
801082fe:	83 c4 10             	add    $0x10,%esp
80108301:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
80108304:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108308:	75 09                	jne    80108313 <deallocuvm+0x51>
      a += (NPTENTRIES - 1) * PGSIZE;
8010830a:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
80108311:	eb 54                	jmp    80108367 <deallocuvm+0xa5>
    else if((*pte & PTE_P) != 0){
80108313:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108316:	8b 00                	mov    (%eax),%eax
80108318:	83 e0 01             	and    $0x1,%eax
8010831b:	85 c0                	test   %eax,%eax
8010831d:	74 48                	je     80108367 <deallocuvm+0xa5>
      pa = PTE_ADDR(*pte);
8010831f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108322:	8b 00                	mov    (%eax),%eax
80108324:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108329:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
8010832c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108330:	75 0d                	jne    8010833f <deallocuvm+0x7d>
        panic("kfree");
80108332:	83 ec 0c             	sub    $0xc,%esp
80108335:	68 55 8d 10 80       	push   $0x80108d55
8010833a:	e8 27 82 ff ff       	call   80100566 <panic>
      char *v = p2v(pa);
8010833f:	83 ec 0c             	sub    $0xc,%esp
80108342:	ff 75 ec             	pushl  -0x14(%ebp)
80108345:	e8 56 f5 ff ff       	call   801078a0 <p2v>
8010834a:	83 c4 10             	add    $0x10,%esp
8010834d:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80108350:	83 ec 0c             	sub    $0xc,%esp
80108353:	ff 75 e8             	pushl  -0x18(%ebp)
80108356:	e8 6e a8 ff ff       	call   80102bc9 <kfree>
8010835b:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
8010835e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108361:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80108367:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010836e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108371:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108374:	0f 82 73 ff ff ff    	jb     801082ed <deallocuvm+0x2b>
    }
  }
  return newsz;
8010837a:	8b 45 10             	mov    0x10(%ebp),%eax
}
8010837d:	c9                   	leave  
8010837e:	c3                   	ret    

8010837f <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
8010837f:	55                   	push   %ebp
80108380:	89 e5                	mov    %esp,%ebp
80108382:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
80108385:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80108389:	75 0d                	jne    80108398 <freevm+0x19>
    panic("freevm: no pgdir");
8010838b:	83 ec 0c             	sub    $0xc,%esp
8010838e:	68 5b 8d 10 80       	push   $0x80108d5b
80108393:	e8 ce 81 ff ff       	call   80100566 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80108398:	83 ec 04             	sub    $0x4,%esp
8010839b:	6a 00                	push   $0x0
8010839d:	68 00 00 00 80       	push   $0x80000000
801083a2:	ff 75 08             	pushl  0x8(%ebp)
801083a5:	e8 18 ff ff ff       	call   801082c2 <deallocuvm>
801083aa:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801083ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801083b4:	eb 4f                	jmp    80108405 <freevm+0x86>
    if(pgdir[i] & PTE_P){
801083b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083b9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801083c0:	8b 45 08             	mov    0x8(%ebp),%eax
801083c3:	01 d0                	add    %edx,%eax
801083c5:	8b 00                	mov    (%eax),%eax
801083c7:	83 e0 01             	and    $0x1,%eax
801083ca:	85 c0                	test   %eax,%eax
801083cc:	74 33                	je     80108401 <freevm+0x82>
      char * v = p2v(PTE_ADDR(pgdir[i]));
801083ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083d1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801083d8:	8b 45 08             	mov    0x8(%ebp),%eax
801083db:	01 d0                	add    %edx,%eax
801083dd:	8b 00                	mov    (%eax),%eax
801083df:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801083e4:	83 ec 0c             	sub    $0xc,%esp
801083e7:	50                   	push   %eax
801083e8:	e8 b3 f4 ff ff       	call   801078a0 <p2v>
801083ed:	83 c4 10             	add    $0x10,%esp
801083f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
801083f3:	83 ec 0c             	sub    $0xc,%esp
801083f6:	ff 75 f0             	pushl  -0x10(%ebp)
801083f9:	e8 cb a7 ff ff       	call   80102bc9 <kfree>
801083fe:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80108401:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108405:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
8010840c:	76 a8                	jbe    801083b6 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010840e:	83 ec 0c             	sub    $0xc,%esp
80108411:	ff 75 08             	pushl  0x8(%ebp)
80108414:	e8 b0 a7 ff ff       	call   80102bc9 <kfree>
80108419:	83 c4 10             	add    $0x10,%esp
}
8010841c:	90                   	nop
8010841d:	c9                   	leave  
8010841e:	c3                   	ret    

8010841f <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
8010841f:	55                   	push   %ebp
80108420:	89 e5                	mov    %esp,%ebp
80108422:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108425:	83 ec 04             	sub    $0x4,%esp
80108428:	6a 00                	push   $0x0
8010842a:	ff 75 0c             	pushl  0xc(%ebp)
8010842d:	ff 75 08             	pushl  0x8(%ebp)
80108430:	e8 ed f8 ff ff       	call   80107d22 <walkpgdir>
80108435:	83 c4 10             	add    $0x10,%esp
80108438:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
8010843b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010843f:	75 0d                	jne    8010844e <clearpteu+0x2f>
    panic("clearpteu");
80108441:	83 ec 0c             	sub    $0xc,%esp
80108444:	68 6c 8d 10 80       	push   $0x80108d6c
80108449:	e8 18 81 ff ff       	call   80100566 <panic>
  *pte &= ~PTE_U;
8010844e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108451:	8b 00                	mov    (%eax),%eax
80108453:	83 e0 fb             	and    $0xfffffffb,%eax
80108456:	89 c2                	mov    %eax,%edx
80108458:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010845b:	89 10                	mov    %edx,(%eax)
}
8010845d:	90                   	nop
8010845e:	c9                   	leave  
8010845f:	c3                   	ret    

80108460 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80108460:	55                   	push   %ebp
80108461:	89 e5                	mov    %esp,%ebp
80108463:	53                   	push   %ebx
80108464:	83 ec 24             	sub    $0x24,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80108467:	e8 e6 f9 ff ff       	call   80107e52 <setupkvm>
8010846c:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010846f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108473:	75 0a                	jne    8010847f <copyuvm+0x1f>
    return 0;
80108475:	b8 00 00 00 00       	mov    $0x0,%eax
8010847a:	e9 f8 00 00 00       	jmp    80108577 <copyuvm+0x117>
  for(i = 0; i < sz; i += PGSIZE){
8010847f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108486:	e9 c4 00 00 00       	jmp    8010854f <copyuvm+0xef>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
8010848b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010848e:	83 ec 04             	sub    $0x4,%esp
80108491:	6a 00                	push   $0x0
80108493:	50                   	push   %eax
80108494:	ff 75 08             	pushl  0x8(%ebp)
80108497:	e8 86 f8 ff ff       	call   80107d22 <walkpgdir>
8010849c:	83 c4 10             	add    $0x10,%esp
8010849f:	89 45 ec             	mov    %eax,-0x14(%ebp)
801084a2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801084a6:	75 0d                	jne    801084b5 <copyuvm+0x55>
      panic("copyuvm: pte should exist");
801084a8:	83 ec 0c             	sub    $0xc,%esp
801084ab:	68 76 8d 10 80       	push   $0x80108d76
801084b0:	e8 b1 80 ff ff       	call   80100566 <panic>
    if(!(*pte & PTE_P))
801084b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801084b8:	8b 00                	mov    (%eax),%eax
801084ba:	83 e0 01             	and    $0x1,%eax
801084bd:	85 c0                	test   %eax,%eax
801084bf:	75 0d                	jne    801084ce <copyuvm+0x6e>
      panic("copyuvm: page not present");
801084c1:	83 ec 0c             	sub    $0xc,%esp
801084c4:	68 90 8d 10 80       	push   $0x80108d90
801084c9:	e8 98 80 ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
801084ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
801084d1:	8b 00                	mov    (%eax),%eax
801084d3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801084d8:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
801084db:	8b 45 ec             	mov    -0x14(%ebp),%eax
801084de:	8b 00                	mov    (%eax),%eax
801084e0:	25 ff 0f 00 00       	and    $0xfff,%eax
801084e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
801084e8:	e8 79 a7 ff ff       	call   80102c66 <kalloc>
801084ed:	89 45 e0             	mov    %eax,-0x20(%ebp)
801084f0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801084f4:	74 6a                	je     80108560 <copyuvm+0x100>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
801084f6:	83 ec 0c             	sub    $0xc,%esp
801084f9:	ff 75 e8             	pushl  -0x18(%ebp)
801084fc:	e8 9f f3 ff ff       	call   801078a0 <p2v>
80108501:	83 c4 10             	add    $0x10,%esp
80108504:	83 ec 04             	sub    $0x4,%esp
80108507:	68 00 10 00 00       	push   $0x1000
8010850c:	50                   	push   %eax
8010850d:	ff 75 e0             	pushl  -0x20(%ebp)
80108510:	e8 42 cf ff ff       	call   80105457 <memmove>
80108515:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
80108518:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010851b:	83 ec 0c             	sub    $0xc,%esp
8010851e:	ff 75 e0             	pushl  -0x20(%ebp)
80108521:	e8 6d f3 ff ff       	call   80107893 <v2p>
80108526:	83 c4 10             	add    $0x10,%esp
80108529:	89 c2                	mov    %eax,%edx
8010852b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010852e:	83 ec 0c             	sub    $0xc,%esp
80108531:	53                   	push   %ebx
80108532:	52                   	push   %edx
80108533:	68 00 10 00 00       	push   $0x1000
80108538:	50                   	push   %eax
80108539:	ff 75 f0             	pushl  -0x10(%ebp)
8010853c:	e8 81 f8 ff ff       	call   80107dc2 <mappages>
80108541:	83 c4 20             	add    $0x20,%esp
80108544:	85 c0                	test   %eax,%eax
80108546:	78 1b                	js     80108563 <copyuvm+0x103>
  for(i = 0; i < sz; i += PGSIZE){
80108548:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010854f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108552:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108555:	0f 82 30 ff ff ff    	jb     8010848b <copyuvm+0x2b>
      goto bad;
  }
  return d;
8010855b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010855e:	eb 17                	jmp    80108577 <copyuvm+0x117>
      goto bad;
80108560:	90                   	nop
80108561:	eb 01                	jmp    80108564 <copyuvm+0x104>
      goto bad;
80108563:	90                   	nop

bad:
  freevm(d);
80108564:	83 ec 0c             	sub    $0xc,%esp
80108567:	ff 75 f0             	pushl  -0x10(%ebp)
8010856a:	e8 10 fe ff ff       	call   8010837f <freevm>
8010856f:	83 c4 10             	add    $0x10,%esp
  return 0;
80108572:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108577:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010857a:	c9                   	leave  
8010857b:	c3                   	ret    

8010857c <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
8010857c:	55                   	push   %ebp
8010857d:	89 e5                	mov    %esp,%ebp
8010857f:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108582:	83 ec 04             	sub    $0x4,%esp
80108585:	6a 00                	push   $0x0
80108587:	ff 75 0c             	pushl  0xc(%ebp)
8010858a:	ff 75 08             	pushl  0x8(%ebp)
8010858d:	e8 90 f7 ff ff       	call   80107d22 <walkpgdir>
80108592:	83 c4 10             	add    $0x10,%esp
80108595:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80108598:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010859b:	8b 00                	mov    (%eax),%eax
8010859d:	83 e0 01             	and    $0x1,%eax
801085a0:	85 c0                	test   %eax,%eax
801085a2:	75 07                	jne    801085ab <uva2ka+0x2f>
    return 0;
801085a4:	b8 00 00 00 00       	mov    $0x0,%eax
801085a9:	eb 29                	jmp    801085d4 <uva2ka+0x58>
  if((*pte & PTE_U) == 0)
801085ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085ae:	8b 00                	mov    (%eax),%eax
801085b0:	83 e0 04             	and    $0x4,%eax
801085b3:	85 c0                	test   %eax,%eax
801085b5:	75 07                	jne    801085be <uva2ka+0x42>
    return 0;
801085b7:	b8 00 00 00 00       	mov    $0x0,%eax
801085bc:	eb 16                	jmp    801085d4 <uva2ka+0x58>
  return (char*)p2v(PTE_ADDR(*pte));
801085be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085c1:	8b 00                	mov    (%eax),%eax
801085c3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801085c8:	83 ec 0c             	sub    $0xc,%esp
801085cb:	50                   	push   %eax
801085cc:	e8 cf f2 ff ff       	call   801078a0 <p2v>
801085d1:	83 c4 10             	add    $0x10,%esp
}
801085d4:	c9                   	leave  
801085d5:	c3                   	ret    

801085d6 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801085d6:	55                   	push   %ebp
801085d7:	89 e5                	mov    %esp,%ebp
801085d9:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
801085dc:	8b 45 10             	mov    0x10(%ebp),%eax
801085df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
801085e2:	eb 7f                	jmp    80108663 <copyout+0x8d>
    va0 = (uint)PGROUNDDOWN(va);
801085e4:	8b 45 0c             	mov    0xc(%ebp),%eax
801085e7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801085ec:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
801085ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
801085f2:	83 ec 08             	sub    $0x8,%esp
801085f5:	50                   	push   %eax
801085f6:	ff 75 08             	pushl  0x8(%ebp)
801085f9:	e8 7e ff ff ff       	call   8010857c <uva2ka>
801085fe:	83 c4 10             	add    $0x10,%esp
80108601:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80108604:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80108608:	75 07                	jne    80108611 <copyout+0x3b>
      return -1;
8010860a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010860f:	eb 61                	jmp    80108672 <copyout+0x9c>
    n = PGSIZE - (va - va0);
80108611:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108614:	2b 45 0c             	sub    0xc(%ebp),%eax
80108617:	05 00 10 00 00       	add    $0x1000,%eax
8010861c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
8010861f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108622:	3b 45 14             	cmp    0x14(%ebp),%eax
80108625:	76 06                	jbe    8010862d <copyout+0x57>
      n = len;
80108627:	8b 45 14             	mov    0x14(%ebp),%eax
8010862a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
8010862d:	8b 45 0c             	mov    0xc(%ebp),%eax
80108630:	2b 45 ec             	sub    -0x14(%ebp),%eax
80108633:	89 c2                	mov    %eax,%edx
80108635:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108638:	01 d0                	add    %edx,%eax
8010863a:	83 ec 04             	sub    $0x4,%esp
8010863d:	ff 75 f0             	pushl  -0x10(%ebp)
80108640:	ff 75 f4             	pushl  -0xc(%ebp)
80108643:	50                   	push   %eax
80108644:	e8 0e ce ff ff       	call   80105457 <memmove>
80108649:	83 c4 10             	add    $0x10,%esp
    len -= n;
8010864c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010864f:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80108652:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108655:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80108658:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010865b:	05 00 10 00 00       	add    $0x1000,%eax
80108660:	89 45 0c             	mov    %eax,0xc(%ebp)
  while(len > 0){
80108663:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80108667:	0f 85 77 ff ff ff    	jne    801085e4 <copyout+0xe>
  }
  return 0;
8010866d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108672:	c9                   	leave  
80108673:	c3                   	ret    
