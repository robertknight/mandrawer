#!/usr/bin/env python3

"""
Rebase all local branches in a repository.
"""

from subprocess import PIPE, run

def main():
    # Check for clean local working tree
    status_res = run(['git', 'status', '--short'], stdout=PIPE)
    entries = [e for e in status_res.stdout.decode('utf-8').split('\n') if e]
    for entry in entries:
        [status, path] = entry.split(' ')
        if status != '??':
            print('Working directory is not clean')


    # List unmerged Git branches
    branch_list_res = run(['git', 'branch', '--no-merged'], stdout=PIPE)
    if branch_list_res.returncode:
        raise "Listing remote branches failed"

    branch_list = [b.decode('utf-8').strip()
        for b in branch_list_res.stdout.strip().split(b'\n')]

    # Rebase each branch in turn
    onto_branch = 'master'
    for branch in branch_list:
        co_result = run(['git', 'checkout', branch], stdout=PIPE)
        if co_result.returncode:
            print('{} - Checkout failed'.format(branch))
            return

        rebase_result = run(['git', 'rebase', onto_branch], stdout=PIPE)
        if rebase_result.returncode:
            abort_result = run(['git', 'rebase', '--abort'])
            if abort_result.returncode:
                print('Rebasing {} failed'.format(abort_result))
                return
            print('{} - Auto-rebase failed'.format(branch))
        else:
            print('{} - Rebased'.format(branch))


if __name__ == '__main__':
    main()
