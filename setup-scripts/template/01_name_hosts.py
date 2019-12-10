
if __name__=='__main__':
    with open("/etc/hosts", "a") as fh:
        for i in range(1, 230):
            fh.write('10.23.23.%d node%d node_%d ip-10-23-23-%d\n' % (i + 10, i, i, i + 10))